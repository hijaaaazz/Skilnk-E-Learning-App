import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/data/models/student_model.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';


abstract class ChatFirebaseService {
  Future<List<AppMessage>> loadMessages(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required String userId,
    required String courseId,
    required String text,
  });
  Future<String> checkChatExists({
    required String userId,
    required String studentId,
  });

  Future<Either<String,List<StudentChat>>> loadChatList({
    required String userId,
  });
}



class ChatFirebaseServiceImp implements ChatFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<AppMessage>> loadMessages(String chatId) async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => AppMessage.fromFirestore(doc.data(), doc.id)).toList();
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String userId,
    required String courseId,
    required String text,
  }) async {
    final messageRef = _firestore.collection('chats').doc(chatId).collection('messages').doc();

    await messageRef.set({
      'userId': userId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).set({
      'userId': userId,
      'tutorId': courseId,
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<String> checkChatExists({
    required String userId,
    required String studentId,
  }) async {
    final chatId = '${studentId}_$userId';
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
Future<Either<String, List<StudentChat>>> loadChatList({required String userId}) async {
  try {
    // Fetch chats where tutorId == userId (tutor perspective)
    final querySnapshot = await _firestore
        .collection('chats')
        .where('tutorId', isEqualTo: userId)
        .orderBy('lastMessageAt', descending: true)
        .get();

    final List<StudentChat> studentChats = [];

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final chatId = doc.id;
      final studentId = data['userId'] as String?;

      if (studentId == null) continue;

      final studentDoc = await _firestore.collection('users').doc(studentId).get();
      if (!studentDoc.exists) continue;

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

    return Right(studentChats);
  } catch (e) {
    log('[loadChatList] Error: $e');
    return Left('Failed to load chat list');
  }
}

}
