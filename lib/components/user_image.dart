import 'dart:io';

import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final File? image;

  const UserImage({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey),
        ),
        child: image != null
            ? Image.file(
                image!,
                width: 125,
                height: 125,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/user_image_placeholder.png',
                width: 125,
                height: 125,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
