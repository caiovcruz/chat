import 'package:flutter/material.dart';

import '../components/auth_form.dart';
import '../models/auth_form_data.dart';
import '../utils/loading_util.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      setState(() => _isLoading = true);

      if (formData.isLogin) {
        // Login
      } else {
        // Sign Up
      }
    } catch (error) {
      // Handle exception
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: AuthForm(onSubmit: _handleSubmit),
              ),
            ),
          ),
          if (_isLoading)
            LoadingUtil.showLoadingCover(
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }
}
