import 'package:bloc/bloc.dart';
import 'package:flutter_demo/core/utils/bloc_extensions.dart';
import 'package:flutter_demo/core/utils/either_extensions.dart';
import 'package:flutter_demo/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:flutter_demo/features/auth/login/login_navigator.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';

class LoginPresenter extends Cubit<LoginViewModel> {
  LoginPresenter(
    LoginPresentationModel super.model,
    this.navigator,
    this.logInUseCase,
  );

  final LoginNavigator navigator;
  final LogInUseCase logInUseCase;

  Function()? get logIn => _model.isLoginEnabled ? _logIn : null;

  // ignore: unused_element
  LoginPresentationModel get _model => state as LoginPresentationModel;

  void usernameChanged(String username) {
    emit(
      _model.copyWith(
        username: username,
        isLoginEnabled: username.isNotEmpty && _model.password.isNotEmpty,
      ),
    );
  }

  void passwordChanged(String password) {
    emit(
      _model.copyWith(
        password: password,
        isLoginEnabled: _model.username.isNotEmpty && password.isNotEmpty,
      ),
    );
  }

  Future<void> _logIn() async {
    await await logInUseCase
        .execute(
          username: _model.username,
          password: _model.password,
        )
        .observeStatusChanges(
          (result) => emit(_model.copyWith(logInResult: result)),
        )
        .asyncFold(
          (fail) => navigator.showError(fail.displayableFailure()),
          (success) => navigator.showAlert(
            title: appLocalizations.congrats,
            message: appLocalizations.logInSuccess,
          ),
        );
  }
}
