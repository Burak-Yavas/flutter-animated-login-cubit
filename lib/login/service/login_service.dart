import 'dart:io';

import 'package:dio/dio.dart';

import '../model/login_request_model.dart';
import '../model/login_response_model.dart';
import '../model/signup_request_model.dart';
import '../model/signup_response_model.dart';
import 'ILoginService.dart';

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model);
    if (response.statusCode == HttpStatus.ok) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<SignUpResponseModel?> postUserSignUp(SignUpRequestModel model) async {
    final response = await dio.post(signUpPath, data: model);
    if (response.statusCode == HttpStatus.ok) {
      return SignUpResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
