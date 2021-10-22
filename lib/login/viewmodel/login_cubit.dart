import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../model/login_request_model.dart';
import '../model/login_response_model.dart';
import '../model/signup_request_model.dart';
import '../model/signup_response_model.dart';
import '../service/ILoginService.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController nameController;

  final TextEditingController emailController;

  final TextEditingController passwordController;

  final GlobalKey<FormState> formKey;

  final ILoginService service;

  bool isLoginFailed = false;

  bool isLoading = false;

  bool isLockOpen = false;

  LoginCubit(
    this.formKey,
    this.emailController,
    this.passwordController, {
    required this.service,
    required this.nameController,
  }) : super(LoginInitial());

  Future<void> postUserModel() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      // changeLoadingView();
      final data = await service.postUserLogin(LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim()));
      // changeLoadingView();
      if (data is LoginResponseModel) {
        emit(LoginComplete(data));
      }
    } else {
      isLoginFailed = true;
      emit(LoginValidateState(isLoginFailed));
    }
  }

  Future<void> postSignUpModel() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      final data = await service.postUserSignUp(SignUpRequestModel(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim()));
      if (data is SignUpResponseModel) {
        emit(SignUpComplete(data));
      }
    } else {
      isLoginFailed = true;
      emit(LoginValidateState(isLoginFailed));
    }
  }

  void changeLockView() {
    isLockOpen = !isLockOpen;
    emit(LoginLockState(isLockOpen));
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginComplete extends LoginState {
  final LoginResponseModel model;

  LoginComplete(this.model);
}

class SignUpComplete extends LoginState {
  final SignUpResponseModel signUpModel;

  SignUpComplete(this.signUpModel);
}

class LoginValidateState extends LoginState {
  final bool isValidate;
  LoginValidateState(this.isValidate);
}

class LoginLoadingState extends LoginState {
  final bool isLoading;
  LoginLoadingState(this.isLoading);
}

class LoginLockState extends LoginState {
  final bool isLockOpen;
  LoginLockState(this.isLockOpen);
}
