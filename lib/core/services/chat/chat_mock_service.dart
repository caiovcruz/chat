import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';

import 'package:chat/core/models/chat_message.dart';

import 'chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Good Morning!',
      createdAt: DateTime.now(),
      userId: '123',
      userName: 'Loid',
      userImageURL: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '1',
      text: 'Good Morning. We\'ll have reunion today?',
      createdAt: DateTime.now(),
      userId: '456',
      userName: 'Yor',
      userImageURL: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '1',
      text: 'Yes. We will, now.',
      createdAt: DateTime.now(),
      userId: '123',
      userName: 'Loid',
      userImageURL: 'assets/images/avatar.png',
    ),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _messagesStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    _controller?.add(_messages);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() => _messagesStream;

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newChatMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );

    _messages.add(newChatMessage);
    _controller?.add(_messages);

    return newChatMessage;
  }
}
