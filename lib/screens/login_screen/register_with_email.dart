import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/helpers/helper_implement.dart';
import 'package:study_english_app/helpers/helpers.dart';
import 'package:study_english_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:study_english_app/screens/login_screen/email_verification_screen.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';
import 'package:study_english_app/widgets/text/edit_text.dart';
import 'package:study_english_app/widgets/text/edit_text_with_suffix.dart';
import 'package:study_english_app/widgets/text/terms_of_service.dart';

import '../../services/api.dart';

class RegisterWithEmail extends StatelessWidget {
  static const String route = "RegisterWithEmail";

  const RegisterWithEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<Api>()),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
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
          return state.isVerified
              ? Center(child: Text('Email Verified'))
              : Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tạo tài khoản",
                        style: AppTextStyles.headline,
                      ),
                    ),
                    SizedBox(height: 24),
                    LoginForm(width: width),
                  ],
                ),
              );
        },
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
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.Loading) {
          CircularProgressIndicator();
        }
      },
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
              SizedBox(width: widget.width / 2, child: termOfService()),
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
                          if (helper.isValidEmail(email.text) &&
                              helper.isValidPassword(password.text)) {
                            cubit.updateEmail(email.text);
                            cubit.updatePassword(password.text);
                            await cubit.registerWithEmail(
                              email.text,
                              password.text,
                            );
                            if (!context.mounted) return;
                            if (cubit.state.loadStatus == LoadStatus.Success) {
                              await cubit.sendVerificationEmail();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (_) =>
                                        EmailVerificationDialog(cubit: cubit),
                              );
                            }
                          } else {
                            if (!helper.isValidEmail(email.text)) {
                              showMyDialog(
                                context,
                                'Thông báo',
                                'Email không hợp lệ!',
                              );
                            } else if (!helper.isValidPassword(password.text)) {
                              showMyDialog(
                                context,
                                'Thông báo',
                                'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!',
                              );
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(27),
                        highlightColor: AppColors.primaryDark,
                        child: Center(
                          child: Text(
                            "Tạo tài khoản",
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

class EmailVerificationDialog extends StatefulWidget {
  const EmailVerificationDialog({super.key, required this.cubit});

  final LoginCubit cubit;

  @override
  State<EmailVerificationDialog> createState() =>
      _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  Timer? _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      if (_secondsRemaining <= 0) {
        _timer?.cancel();
        widget.cubit.deleteUser();
        if (!context.mounted) return;
        Navigator.of(context).pop();
        return;
      }

      setState(() {
        _secondsRemaining--;
      });

      await widget.cubit.checkEmailVerified();
      if (widget.cubit.state.isVerified) {
        _timer?.cancel();
        if (!context.mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(LoginWithEmailScreen.route);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Xác minh email"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Chúng tôi đã gửi email xác nhận đến email bạn vừa đăng ký, vui lòng nhấp vào liên kết trong email để xác minh email...",
          ),
          SizedBox(height: 16),
          _secondsRemaining <= 0
              ? Center(child: Text('Vui lòng thử lại!'))
              : CircularProgressIndicator(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.cubit.sendVerificationEmail();
          },
          child: Text("Gửi lại email xác minh"),
        ),
        TextButton(
          onPressed: () {
            _timer?.cancel();
            widget.cubit.deleteUser();
            Navigator.of(context).pop();
          },
          child: Text("Đóng"),
        ),
      ],
    );
  }
}
