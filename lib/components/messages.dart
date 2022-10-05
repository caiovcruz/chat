import 'package:flutter/material.dart';

import '../core/models/chat_message.dart';
import '../core/services/auth/auth_service.dart';
import '../core/services/chat/chat_service.dart';
import '../utils/loading_util.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder<List<ChatMessage>>(
      stream: ChatService().messagesStream(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingUtil.showLoading();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No messages. Let\'s talk?'),
          );
        } else {
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (ctx, index) => MessageBubble(
              key: ValueKey(messages[index].id),
              message: messages[index],
              belongsToCurrentUser: currentUser?.id == messages[index].userId,
            ),
          );
        }
      },
    );
  }
}
