// lib/features/chat/data/service/firebase_chat.dart
// ignore_for_file: unused_import

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import  'package:user_app/features/chat/data/models/chat_model.dart';
import  'package:user_app/features/chat/data/models/messgae_class.dart';
import  'package:user_app/features/home/data/models/mentor_mode.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class ChatFirebaseService {
  Stream<List<AppMessage>> loadMessages(String chatId);
  Future<void> sendMessage({
    required String userId,
    required String courseId,
    required String text,
  });
  Future<String> checkChatExists({
    required String userId,
    required String tutorId,
  });
  Stream<Either<String, List<TutorChat>>> loadChatList({
    required String userId,
  });
}


class ChatFirebaseServiceImpl implements ChatFirebaseService {
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
  required String userId,
  required String courseId,
  required String text,
}) async {
  if ("${userId}_$courseId".trim().isEmpty) {
    log('[sendMessage] Error: chatId is empty!');
    throw Exception("Chat ID cannot be empty");
  }

  final messageRef =
      _firestore.collection('chats').doc("${userId}_$courseId").collection('messages').doc();

  await messageRef.set({
    'userId': userId,
    'text': text,
    'createdAt': FieldValue.serverTimestamp(),
  });

  await _firestore.collection('chats').doc("${userId}_$courseId").set({
    'userId': userId,
    'tutorId': courseId,
    'lastMessage': text,
    'lastMessageAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}


  @override
  Future<String> checkChatExists({
    required String userId,
    required String tutorId,
  }) async {
    log("yugbuyuhuihiuohuihuihuihuhuhui${userId}_$tutorId");
    final chatId = '${userId}_$tutorId';
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'userId': userId,
        'tutorId': tutorId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      log('Created new chat document: $chatId');
    }

    return chatId;
  }

  
  @override
Stream<Either<String, List<TutorChat>>> loadChatList({
  required String userId,
}) async* {
  try {
    log('[loadChatList] userId: $userId');

    yield* _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .asyncMap<Either<String, List<TutorChat>>>((querySnapshot) async {
      final List<TutorChat> tutorChats = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final chatId = doc.id;

        log('[loadChatList] Processing chatId: $chatId');
        log('[loadChatList] Raw data: $data');

        final dynamic tutorId = data['tutorId'];
        if (tutorId == null || tutorId is! String) {
          log('[loadChatList] Skipped: Invalid tutorId for chatId $chatId');
          continue;
        }

        final mentorDoc = await _firestore.collection('mentors').doc(tutorId).get();
        if (!mentorDoc.exists) {
          log('[loadChatList] Skipped: mentor doc not found for $tutorId');
          continue;
        }

        final mentorData = mentorDoc.data();
        if (mentorData == null) {
          log('[loadChatList] Skipped: mentor data null for $tutorId');
          continue;
        }

        final mentorEntity = MentorModel.fromJson(mentorData).toEntity();

        tutorChats.add(TutorChat(
          chatId: chatId,
          user: mentorEntity,
          lastMessage: data['lastMessage'] as String?,
          lastmessagedAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
        ));
      }

      log('[loadChatList] Total chats: ${tutorChats.length}');
      return Right(tutorChats);
    }).handleError((e, stack) {
      log('[loadChatList] Error inside stream: $e');
      log('[loadChatList] Stack: $stack');
      return Left('Failed to load chat list');
    });
  } catch (e, stack) {
    log('[loadChatList] Fatal error: $e');
    log('[loadChatList] Stack: $stack');
    yield Left('Failed to load chat list');
  }
}

}


