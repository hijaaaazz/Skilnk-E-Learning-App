
// lib/features/chat/data/service/firebase_chat.dart
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/data/models/student_model.dart';
import 'package:tutor_app/features/chat/data/models/stuent_chat_model.dart';

abstract class ChatFirebaseService {
  Stream<List<AppMessage>> loadMessages(String chatId); // Already updated in previous response
  Future<void> sendMessage({
    required String chatId,
    required String userId,
    required String tutorId,
    required String text,
  });
  Future<String> checkChatExists({
    required String userId,
    required String studentId,
  });
  Stream<Either<String, List<StudentChat>>> loadChatList({
    required String userId,
  });
}

class ChatFirebaseServiceImp implements ChatFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<AppMessage>> loadMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppMessage.fromFirestore(doc.data(), doc.id))
            .toList());
  }

 @override
Future<void> sendMessage({
  required String chatId,
  required String userId,
  required String tutorId,
  required String text,
}) async {
  try {
    log('[sendMessage] Called with chatId: $chatId, userId: $userId, tutorId: $tutorId, text: $text');

    final messagePath = "chats/${userId}_$tutorId/messages";
    log(messagePath);
    final messageRef = _firestore
        .collection('chats')
        .doc("${tutorId}_$userId")
        .collection('messages')
        .doc();

    log('[sendMessage] Writing message to: $messagePath/${messageRef.id}');

    await messageRef.set({
      'userId': userId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final chatDocPath = "chats/$chatId";

    log('[sendMessage] Updating chat doc: $chatDocPath');

    await _firestore.collection('chats').doc("${tutorId}_$userId").set({
      'userId': tutorId,
      'tutorId': userId,
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    log('[sendMessage] Message sent successfully.');
  } catch (e, stack) {
    log('[sendMessage] Error: $e');
    log('[sendMessage] StackTrace: $stack');
    rethrow;
  }
}


  @override
  Future<String> checkChatExists({
    required String userId,
    required String studentId,
  }) async {
    log("student$studentId");
    log("tutor$userId");
    final chatId = '${studentId}_$userId';
    log("chat id           $chatId");
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'userId': studentId,
        'tutorId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      log('Created new chat document: $chatId');
    }

    return chatId;
  }

  @override
  Stream<Either<String, List<StudentChat>>> loadChatList({
    required String userId,
  }) {
    return _firestore
        .collection('chats')
        .where('tutorId', isEqualTo: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      try {
        final List<StudentChat> studentChats = [];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          final chatId = doc.id;
          final studentId = data['userId'] as String?;

          if (studentId == null) {
            log('[loadChatList] Skipped: studentId is null for chatId $chatId');
            continue;
          }

          final studentDoc =
              await _firestore.collection('users').doc(studentId).get();
          if (!studentDoc.exists) {
            log('[loadChatList] Skipped: student document does not exist for $studentId');
            continue;
          }

          final studentData = studentDoc.data()!;
          final studentEntity = StudentEntity.fromJson(studentData, studentDoc.id);

          final studentChat = StudentChat(
            chatId: chatId,
            user: studentEntity,
            lastMessage: data['lastMessage'] as String?,
            lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
          );

          studentChats.add(studentChat);
        }

        log('[loadChatList] Total loaded chats: ${studentChats.length}');
        return Right(studentChats);
      } catch (e) {
        log('[loadChatList] Error: $e');
        return Left('Failed to load chat list');
      }
    });
  }
}