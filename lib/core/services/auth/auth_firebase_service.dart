import 'dart:async';
import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user != null ? _toChatUser(user) : null;
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser => _currentUser;

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  @override
  Future<void> signUp(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    FirebaseApp tempApp = await Firebase.initializeApp(
      name: 'temporaryRegister',
      options: Firebase.app().options,
    );

    final tempAuth = await FirebaseAuth.instanceFor(
      app: tempApp,
    ).createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (tempAuth.user != null) {
      // 1. Upload user's photo
      final imageName = '${tempAuth.user!.uid}.jpg';
      final imageURL = await _uploadUserImage(image, imageName);

      // 2. Update user's attributes
      await tempAuth.user?.updateDisplayName(name);
      await tempAuth.user?.updatePhotoURL(imageURL);

      // 3. Login the new user
      await login(email, password);

      // 4. Save user on database (optional)
      await _saveChatUser(_toChatUser(tempAuth.user!));
    }

    await tempApp.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return await docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
    });
  }

  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageURL: user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
