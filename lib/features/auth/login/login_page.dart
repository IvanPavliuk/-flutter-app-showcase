// ignore: unused_import
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/mvp_extensions.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';

class LoginPage extends StatefulWidget with HasPresenter<LoginPresenter> {
  const LoginPage({
    required this.presenter,
    super.key,
  });

  @override
  final LoginPresenter presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with PresenterStateMixin<LoginViewModel, LoginPresenter, LoginPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: stateObserver(
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: appLocalizations.usernameHint,
                  ),
                  onChanged: presenter.usernameChanged,
                ),
                const SizedBox(height: 8),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: appLocalizations.passwordHint,
                  ),
                  onChanged: presenter.passwordChanged,
                ),
                const SizedBox(height: 16),
                if (state.isLoading)
                  const CircularProgressIndicator()
                else
                  stateObserver(
                    builder: (context, state) => ElevatedButton(
                      onPressed: presenter.logIn,
                      child: Text(appLocalizations.logInAction),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
