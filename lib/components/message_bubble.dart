import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  static const _defaultImage = 'assets/images/avatar.png';
  final ChatMessage message;
  final bool belongsToCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.belongsToCurrentUser,
  }) : super(key: key);

  Widget _showUserImage(String imageURL) {
    ImageProvider? provider;
    final uri = Uri.parse(imageURL);

    if (uri.path.contains(_defaultImage)) {
      provider = const AssetImage(_defaultImage);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.black45,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        backgroundImage: provider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: belongsToCurrentUser
                    ? Colors.grey.shade300
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: belongsToCurrentUser
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: !belongsToCurrentUser
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.45,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: belongsToCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    belongsToCurrentUser ? 'You' : message.userName,
                    style: TextStyle(
                      color: belongsToCurrentUser ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message.text,
                    textAlign:
                        belongsToCurrentUser ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      color: belongsToCurrentUser ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: belongsToCurrentUser
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      DateFormat('EEE').add_Hm().format(message.createdAt),
                      style: TextStyle(
                        color: belongsToCurrentUser
                            ? Colors.black38
                            : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: belongsToCurrentUser ? null : 165,
          right: !belongsToCurrentUser ? null : 165,
          child: _showUserImage(message.userImageURL),
        ),
      ],
    );
  }
}
