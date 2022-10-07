import 'package:flutter/material.dart';

import '../core/models/chat_message.dart';
import '../core/services/auth/auth_service.dart';
import '../core/services/chat/chat_service.dart';
import '../utils/loading_util.dart';
import 'message_bubble.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _scrollController = ScrollController();
  final _showScrollToEnd = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        _showScrollToEnd.value = _scrollController.offset > 400 ? true : false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder<List<ChatMessage>>(
      stream: ChatService().messagesStream(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingUtil.showLoading(
            color: Theme.of(context).colorScheme.primary,
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No messages. Let\'s talk?'),
          );
        } else {
          final messages = snapshot.data!.reversed.toList();
          return Stack(
            children: [
              Positioned.fill(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) => MessageBubble(
                    key: ValueKey(messages[index].id),
                    message: messages[index],
                    belongsToCurrentUser:
                        currentUser?.id == messages[index].userId,
                  ),
                ),
              ),
              if (_showScrollToEnd.value)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton(
                      onPressed: _scrollToEnd,
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_circle_down_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}
