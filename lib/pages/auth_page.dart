import 'package:flutter/material.dart';

import '../components/auth_form.dart';
import '../models/auth_form_data.dart';
import '../utils/loading_util.dart';
import 'loading_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  void _handleSubmit(AuthFormData formData) {
    setState(() => _isLoading = true);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
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
