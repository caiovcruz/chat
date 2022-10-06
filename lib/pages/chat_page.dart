import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/messages.dart';
import '../components/new_message.dart';
import '../core/services/auth/auth_service.dart';
import '../core/services/notification/chat_notification_service.dart';
import 'notification_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talk.To Chat'),
        centerTitle: true,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 10),
                      Text('Logout')
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const NotificationPage(),
                )),
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                    Provider.of<ChatNotificationService>(context)
                        .resumedItemsCount,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: const Messages(),
              ),
            ),
            const NewMessage(),
          ],
        ),
      ),
    );
  }
}
