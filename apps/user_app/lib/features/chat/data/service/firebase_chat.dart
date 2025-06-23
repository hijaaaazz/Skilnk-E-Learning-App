import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:user_app/features/chat/data/models/messgae_class.dart';


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
    required String courseId,
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
    required String courseId,
  }) async {
    final chatId = '${userId}_${courseId}';
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'userId': userId,
        'tutorId': courseId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      log('Created new chat document: $chatId');
    }

    return chatId;
  }
}
