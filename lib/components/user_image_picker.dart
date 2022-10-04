import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'user_image.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File) onImagePick;

  const UserImagePicker({
    Key? key,
    required this.onImagePick,
  }) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  Future<void> _pickImage({bool isFromGallery = false}) async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserImage(image: _image),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () => _manageImage(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              const Text('Manage image'),
            ],
          ),
        ),
      ],
    );
  }

  void _manageImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  _pickImage();
                  Navigator.of(ctx).pop();
                },
                icon: const Icon(Icons.photo_camera_rounded),
                label: const Text('Take a picture'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _pickImage(isFromGallery: true);
                  Navigator.of(ctx).pop();
                },
                icon: const Icon(Icons.image_search_rounded),
                label: const Text('Choose from gallery'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        width: 1, color: Colors.red, style: BorderStyle.solid)),
                child: const Text(
                  "Remove image",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  setState(() => _image = null);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
