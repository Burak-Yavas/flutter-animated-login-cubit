import 'package:dio/dio.dart';
import 'package:login_cubit/login/model/login_request_model.dart';
import 'package:login_cubit/login/model/login_response_model.dart';
import 'package:login_cubit/login/model/signup_request_model.dart';
import 'package:login_cubit/login/model/signup_response_model.dart';

abstract class ILoginService {
  final Dio dio;

  final String loginPath = ILoginServicePath.LOGIN.rawValue;
  final String signUpPath = ILoginServicePath.SIGNUP.rawValue;

  ILoginService(this.dio);

  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model);
  Future<SignUpResponseModel?> postUserSignUp(SignUpRequestModel model);
}

enum ILoginServicePath { LOGIN, SIGNUP }

extension ILoginServicePathExtension on ILoginServicePath {
  String get rawValue {
    switch (this) {
      case ILoginServicePath.LOGIN:
        return "/login";
      case ILoginServicePath.SIGNUP:
        return "/register";
    }
  }
}
