import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/helpers/helper_implement.dart';
import 'package:study_english_app/helpers/helpers.dart';
import 'package:study_english_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:study_english_app/screens/main_screen/main_screen.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

import '../../common/enum/load_status.dart';
import '../../services/api.dart';
import '../../widgets/button/primary_button.dart';
import '../../core/color.dart';
import '../../core/text.dart';
import '../../widgets/text/edit_text.dart';
import '../../widgets/text/edit_text_with_suffix.dart';

class LoginWithEmailScreen extends StatelessWidget {
  const LoginWithEmailScreen({super.key});

  static const String route = "LoginWithEmailScreen";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => LoginCubit(context.read<Api>()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            var cubit = context.read<LoginCubit>();
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Đăng nhập",
                            style: AppTextStyles.headline,
                          ),
                        ),
                        SizedBox(height: 24),
                        LoginForm(width: width),
                      ],
                    ),
                  ),
                  primaryButton(true, "Continue with Google", 18, () async {
                    await cubit.loginWithGoogle();
                    if (!context.mounted) return;
                    if (cubit.state.loadStatus == LoadStatus.Success) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.route,
                            (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Login failed")));
                    }
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.width});

  final double width;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isActive = false;
  TextEditingController email = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  Helper helper = HelperImplement();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return SizedBox(
          width: widget.width,
          child: Column(
            children: [
              editText("Email", email, () {
                setState(() {
                  isActivated(email.text, password.text);
                });
              }, () {}),
              SizedBox(height: 16),
              editTextWithSuffix("Password", password, () {
                setState(() {
                  isActivated(email.text, password.text);
                });
              }, () {}),
              SizedBox(height: 24),
              SizedBox(
                width: widget.width,
                height: 40,
                child: Opacity(
                  opacity: isActive ? 1 : 0.3,
                  child: IgnorePointer(
                    ignoring: !isActive,
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            isActive
                                ? AppColors.primaryBlue
                                : AppColors.lightGray,
                      ),
                      child: InkWell(
                        onTap: () async {
                          if(helper.isValidEmail(email.text) && helper.isValidPassword(password.text)) {
                            await cubit.loginWithEmail(
                              email.text,
                              password.text,
                            );
                            if (!context.mounted) return;
                            if (cubit.state.loadStatus == LoadStatus.Success) {
                              showMyDialog(context, 'Thông báo', 'Đăng nhâp thành công!');
                              Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.route, (route) => false);
                            } else if (cubit.state.loadStatus == LoadStatus.Error) {
                              showMyDialog(context, 'Thông báo', 'Đăng nhâp không thành công!');
                            }
                          } else {
                            if(!helper.isValidEmail(email.text)) {
                              showMyDialog(context, 'Thông báo', 'Email không hợp lệ!');
                            } else if(!helper.isValidPassword(password.text)) {
                              showMyDialog(context, 'Thông báo',
                                  'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!');
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(27),
                        highlightColor: AppColors.primaryDark,
                        child: Center(
                          child: Text(
                            "Đăng nhập",
                            style:
                                isActive
                                    ? AppTextStyles.primaryButton
                                    : AppTextStyles.button,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Quên mật khẩu"),
                      content: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: "Nhập email của bạn",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            if (email.text.isNotEmpty) {
                              await cubit.resetPassword(email.text);
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text("Thông báo"),
                                  content: Text("Đã gửi email đặt lại mật khẩu đến ${email.text}"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              });
                            } else {
                              showMyDialog(context, 'Thông báo', 'Vui lòng nhập email!');
                            }
                          },
                          child: Text("Gửi"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Hủy"),
                        ),
                      ],
                    );
                  });
                },
                child: Text(
                  "Quên mật khẩu",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void isActivated(String emailText, String passwordText) {
    final active = emailText.isNotEmpty && passwordText.isNotEmpty;
    if (active != isActive) {
      isActive = active;
    }
  }
}
