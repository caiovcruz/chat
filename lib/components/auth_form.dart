import 'dart:io';

import 'package:flutter/material.dart';

import '../core/models/auth_form_data.dart';
import '../utils/text_field_validator.dart';
import 'user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _onImagePick(File image) {
    _formData.image = image;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (_formData.isSignUp)
                UserImagePicker(onImagePick: _onImagePick),
              if (_formData.isSignUp)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: nameValidator,
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: emailValidator,
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: passwordValidator,
              ),
              if (_formData.isSignUp)
                TextFormField(
                  key: const ValueKey('confirmPassword'),
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: confirmPasswordValidator,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _formData.toggleAuthMode()),
                    child: Text(_formData.isLogin
                        ? 'Create a new account?'
                        : 'Already have an account?'),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(_formData.isLogin ? 'Login' : 'Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? nameValidator(name) {
    final trimmedName = (name ?? '').trim();

    final validations = [
      TextFieldValidator.required('Name', trimmedName),
      TextFieldValidator.minLength('Name', trimmedName, 3),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? emailValidator(email) {
    final trimmedEmail = (email ?? '').trim();

    final validations = [
      TextFieldValidator.required('Email', trimmedEmail),
      TextFieldValidator.email('Email', trimmedEmail),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? passwordValidator(password) {
    final trimmedPassword = (password ?? '').trim();

    final validations = [
      TextFieldValidator.required('Password', trimmedPassword),
      if (_formData.isSignUp)
        TextFieldValidator.minLength('Password', trimmedPassword, 8),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? confirmPasswordValidator(password) {
    final trimmedPassword = (password ?? '').trim();

    final validations = [
      TextFieldValidator.required('Confirm Password', trimmedPassword),
      TextFieldValidator.match(
          'Confirm Password', trimmedPassword, _formData.password.trim()),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }
}
