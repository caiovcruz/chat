import 'package:flutter/material.dart';

class MessengerUtil {
  static void showMessage({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Theme.of(context).errorColor : null,
    ));
  }
}
