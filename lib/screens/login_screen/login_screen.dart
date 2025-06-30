import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/screens/login_screen/register_with_email.dart';
import 'package:study_english_app/services/api.dart';
import 'package:study_english_app/widgets/button/button.dart';
import 'package:study_english_app/widgets/button/primary_button.dart';
import 'package:study_english_app/widgets/text/terms_of_service.dart';
import '../../common/enum/load_status.dart';
import '../main_screen/main_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<Api>()),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    double spacing = height / 25;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: SizedBox(width: width, child: Text(""))),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Cách tốt nhất để học. Đăng ký miễn phí.",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    SizedBox(width: width / 2, child: termOfService()),
                    SizedBox(height: spacing),
                    SizedBox(
                      width: width - 100,
                      child: primaryButton(
                        true,
                        "Continue with Google",
                        18,
                        () async {
                          await cubit.loginWithGoogle();
                          if (!context.mounted) return;
                          if (cubit.state.loadStatus == LoadStatus.Success) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              MainScreen.route,
                                  (route) => false,
                            );
                          } else if (cubit.state.loadStatus == LoadStatus.Error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login failed. Please try again."),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: spacing),
                    SizedBox(
                      width: width - 100,
                      child: button(true, "Register with Email", 18, () {
                        print("register with email");
                        Navigator.of(context).pushNamed(RegisterWithEmail.route);
                      }),
                    ),
                    SizedBox(height: spacing),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Đã có tài khoản? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(LoginWithEmailScreen.route);
                          },
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
