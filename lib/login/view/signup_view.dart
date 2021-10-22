import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/animation/animated_images.dart';
import '../../widgets/animation/fade_animation.dart';
import '../service/login_service.dart';
import '../viewmodel/login_cubit.dart';
import 'login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUpView extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final String baseUrl = "${dotenv.env['HOME_IP']}/api/user";
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return BlocProvider(
      create: (context) => LoginCubit(
          formKey, emailController, passwordController,
          nameController: nameController,
          service: LoginService(Dio(BaseOptions(baseUrl: baseUrl)))),
      child: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
        if (state is SignUpComplete) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LogInView()));
        }
      }, builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(100, 131, 250, 1),
            Color.fromRGBO(160, 160, 200, 1)
          ], begin: Alignment.center, end: Alignment.bottomCenter)),
          child: buildScaffold(context, topPadding, state),
        );
      }),
    );
  }

  Scaffold buildScaffold(
      BuildContext context, double topPadding, LoginState state) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () {
            // call this method here to hide soft keyboard
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: FadeAnimation(
            3,
            buildBodySizedBox(topPadding, context, state),
          ),
        ),
      ),
    );
  }

  Widget buildBodySizedBox(
      double topPadding, BuildContext context, LoginState state) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: formKey,
        autovalidateMode: buildAutoValidate(state),
        child: Column(
          children: [
            SizedBox(height: topPadding),
            const SizedBox(height: 10),
            AnimatedImage(
              "assets/images/image2.png",
              Curves.linear,
              offsetStart: Offset(-0.04, -0.02),
              offsetEnd: Offset(0.01, 0.02),
            ),
            const Spacer(flex: 1),
            buildAnimatedNameForm(),
            const SizedBox(height: 5),
            buildAnimatedEmailForm(),
            const SizedBox(height: 5),
            buildAnimatedPasswordForm(context),
            buildElevatedLogin(context),
            buildSignUpTextButton(context),
            const Spacer(flex: 3)
          ],
        ),
      ),
    );
  }

  AutovalidateMode buildAutoValidate(LoginState state) {
    return state is LoginValidateState
        ? (state.isValidate
            ? AutovalidateMode.always
            : AutovalidateMode.disabled)
        : AutovalidateMode.disabled;
  }

  FadeAnimation buildAnimatedPasswordForm(BuildContext context) {
    return FadeAnimation(
      4,
      Container(
        padding: const EdgeInsets.all(10),
        // color: const Color.fromRGBO(160, 148, 227, 1),
        child: buildPasswordTextFormField(context),
      ),
    );
  }

  FadeAnimation buildAnimatedEmailForm() {
    return FadeAnimation(
      4,
      Container(
        padding: const EdgeInsets.all(10),
        // color: const Color.fromRGBO(160, 148, 227, 1),
        child: buildEmailTextFormField(),
      ),
    );
  }

  FadeAnimation buildAnimatedNameForm() {
    return FadeAnimation(
      4,
      Container(
        padding: const EdgeInsets.all(10),
        // color: const Color.fromRGBO(160, 148, 227, 1),
        child: buildNameTextFormField(),
      ),
    );
  }

  TextButton buildSignUpTextButton(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            primary: Colors.transparent, backgroundColor: Colors.transparent),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LogInView()));
        },
        child: const Text(
          "Already have an account? Login",
          style: TextStyle(color: Colors.black),
        ));
  }

  Widget buildElevatedLogin(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 40),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              primary: Colors.black,
              onPrimary: Colors.black,
              onSurface: Colors.black,
              shadowColor: Colors.black),
          onPressed: () => context.read<LoginCubit>().postSignUpModel(),
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Color.fromRGBO(160, 148, 227, 1)),
          ),
        );
      },
    );
  }

  TextFormField buildPasswordTextFormField(BuildContext context) {
    return TextFormField(
        controller: passwordController,
        obscureText: context.watch<LoginCubit>().isLockOpen,
        cursorColor: Colors.black,
        validator: (value) => (value ?? "").length > 5 ? null : "5 ten kucuk",
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(Icons.vpn_key),
                onPressed: () => context.read<LoginCubit>().changeLockView()),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.4))),
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.black)));
  }

  TextFormField buildEmailTextFormField() {
    return TextFormField(
        controller: emailController,
        cursorColor: Colors.black,
        validator: (value) => (value ?? "").length > 6 ? null : "6 dan kucuk",
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.4))),
            labelText: "Email",
            labelStyle: const TextStyle(color: Colors.black)));
  }

  TextFormField buildNameTextFormField() {
    return TextFormField(
        controller: nameController,
        cursorColor: Colors.black,
        validator: (value) => (value ?? "").length > 5 ? null : "5 dan kucuk",
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.4))),
            labelText: "Name",
            labelStyle: const TextStyle(color: Colors.black)));
  }
}
