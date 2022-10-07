import 'package:flutter/material.dart';

import '../components/auth_form.dart';
import '../core/models/auth_form_data.dart';
import '../core/services/auth/auth_service.dart';
import '../utils/loading_util.dart';
import '../utils/messenger_util.dart';

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
        await AuthService().login(
          formData.email,
          formData.password,
        );

        MessengerUtil.showMessage(
          context: context,
          message: 'Successfully logged in!',
        );
      } else {
        await AuthService().signUp(
          formData.name,
          formData.email,
          formData.password,
          formData.image,
        );

        MessengerUtil.showMessage(
          context: context,
          message: 'Successfully signed up!',
        );
      }
    } catch (error) {
      MessengerUtil.showMessage(
        context: context,
        message: 'Something went wrong. Try again later!',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
