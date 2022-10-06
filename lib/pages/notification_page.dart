import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/notification/chat_notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatNotificationService>(context);
    final items = service.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My notifications'),
        centerTitle: true,
      ),
      body: service.itemsCount > 0
          ? ListView.builder(
              itemCount: service.itemsCount,
              itemBuilder: (ctx, index) => Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  color: Theme.of(context).errorColor,
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
                onDismissed: (_) => service.remove(index),
                child: ListTile(
                  title: Text(items[index].title),
                  subtitle: Text(items[index].body),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, size: 40),
                  SizedBox(height: 10),
                  Text('All right. You\'re up to date!'),
                ],
              ),
            ),
    );
  }
}
