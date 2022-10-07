import 'dart:async';

import 'package:chat/core/models/chat_user.dart';

import 'package:chat/core/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_service.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;

    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy('createdAt')
        .snapshots();

    // Clean
    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });

    // Verbose
    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((snapshot) {
    //     List<ChatMessage> list = snapshot.docs.map((doc) {
    //       return doc.data();
    //     }).toList();
    //     controller.add(list.reversed.toList());
    //   });
    // });
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final message = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );

    // ChatMessage => Map<String, dynamic>
    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(message);

    final doc = await docRef.get();
    return doc.data()!;
  }

  // ChatMessage => Map<String, dynamic>
  Map<String, dynamic> _toFirestore(
    ChatMessage message,
    SetOptions? options,
  ) {
    return {
      'text': message.text,
      'createdAt': message.createdAt.toIso8601String(),
      'userId': message.userId,
      'userName': message.userName,
      'userImageURL': message.userImageURL,
    };
  }

  // Map<String, dynamic> => ChatMessage
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageURL: doc['userImageURL'],
    );
  }
}
