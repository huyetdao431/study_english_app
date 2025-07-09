import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/helpers/helper_implement.dart';
import 'package:study_english_app/helpers/helpers.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/screens/login_screen/login_with_email.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

import '../../core/color.dart';

class EditUserInfoScreen extends StatefulWidget {
  static const String route = 'EditUserInfoScreen';
  final String fieldType;
  final String oldValue;

  const EditUserInfoScreen({
    super.key,
    required this.fieldType,
    required this.oldValue,
  });

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  Helper helper = HelperImplement();
  final TextEditingController _controller = TextEditingController();
  bool obscurePassword = true;
  bool isValidValue = true;
  bool valueNotChanged = false;

  @override
  Widget build(BuildContext context) {
    String label;
    TextInputType inputType = TextInputType.text;

    switch (widget.fieldType) {
      case 'email':
        label = 'Email';
        inputType = TextInputType.emailAddress;
        break;
      case 'password':
        label = 'Mật khẩu';
        break;
      case 'username':
      default:
        label = 'Tên người dùng';
        break;
    }

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        var cubit = context.read<AccountCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Text('Nhập ${label.toLowerCase()}'),
            actions: [
              TextButton(
                onPressed: () async {
                  switch (widget.fieldType) {
                    case 'email':
                      if (!helper.isValidEmail(_controller.text)) {
                        setState(() {
                          isValidValue = false;
                        });
                        return;
                      }
                      if (_controller.text == widget.oldValue) {
                        setState(() {
                          valueNotChanged = true;
                        });
                        return;
                      } else {
                        await cubit.changeEmail(_controller.text);
                        if (!context.mounted) return;
                        if (cubit.state.loadStatus ==
                            LoadStatus.Success) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => EmailVerificationDialog(
                                  cubit: cubit,
                                  newEmail: _controller.text,
                                ),
                          );
                        } else if (cubit.state.loadStatus ==
                            LoadStatus.Error) {
                          showMyDialog(
                            context,
                            'Thông báo',
                            'Có lỗi xảy ra, vui lòng thử lại!',
                          );
                        }
                      }
                      break;
                    case 'password':
                      if (!helper.isValidPassword(_controller.text)) {
                        setState(() {
                          isValidValue = false;
                        });
                        return;
                      }
                      if (_controller.text == widget.oldValue) {
                        setState(() {
                          valueNotChanged = true;
                        });
                        return;
                      } else {
                        await cubit.changePassword(_controller.text);
                        if (!context.mounted) return;
                        if (cubit.state.loadStatus ==
                            LoadStatus.Success) {
                          showMyDialog(
                            context,
                            'Thông báo',
                            'Đổi mật khẩu thành công!',
                          );
                        } else if (cubit.state.loadStatus ==
                            LoadStatus.Error) {
                          showMyDialog(
                            context,
                            'Thông báo',
                            'Có lỗi xảy ra, vui lòng thử lại!',
                          );
                        }
                      }
                      break;
                    case 'username':
                    default:
                      if (_controller.text.isEmpty) {
                        setState(() {
                          isValidValue = false;
                        });
                        return;
                      }
                      if (_controller.text == widget.oldValue) {
                        setState(() {
                          valueNotChanged = true;
                        });
                        return;
                      } else {
                        if(cubit.state.usernameChangeTime < 60) {
                          showMyDialog(
                            context,
                            'Thông báo',
                            'Bạn chỉ có thể đổi tên người dùng sau ${60 - cubit.state.usernameChangeTime} ngày nữa.',
                          );
                          return;
                        } else {
                          await cubit.changeUsername(_controller.text);
                          if (!context.mounted) return;
                          if (cubit.state.loadStatus ==
                              LoadStatus.Success) {
                            showMyDialog(
                              context,
                              'Thông báo',
                              'Đổi tên người dùng thành công!',
                            );
                          } else if (cubit.state.loadStatus ==
                              LoadStatus.Error) {
                            showMyDialog(
                              context,
                              'Thông báo',
                              'Có lỗi xảy ra, vui lòng thử lại!',
                            );
                          }
                        }
                      }
                      break;
                  }
                },
                child: Text(
                  'Lưu',
                  style: TextStyle(color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                widget.fieldType == 'username'
                    ? Text(
                      'Tên người dùng chỉ được đổi duy nhất sau lần gần nhất 60 ngày (còn ${cubit.state.usernameChangeTime == 0 ? 0 : 60 - cubit.state.usernameChangeTime == 0} ngày).',
                    )
                    : const SizedBox.shrink(),
                TextField(
                  controller: _controller,
                  keyboardType: inputType,
                  obscureText:
                      widget.fieldType == 'password' ? obscurePassword : false,
                  decoration: InputDecoration(
                    labelText: label,
                    suffixIcon:
                        widget.fieldType == 'password'
                            ? IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            )
                            : null,
                  ),
                ),
                SizedBox(height: 8),
                if (!isValidValue)
                  if (widget.fieldType == 'email')
                    if (valueNotChanged)
                      Text(
                        'Bạn đã dùng email này cho tài khoản hiện tại, vui lòng đổi email khác.',
                        style: TextStyle(color: AppColors.errorRed),
                      )
                    else
                      Text(
                        'Email không hợp lệ.',
                        style: TextStyle(color: AppColors.errorRed),
                      )
                  else if (widget.fieldType == 'password')
                    if (valueNotChanged)
                      Text(
                        'Bạn đã dùng mật khẩu này cho tài khoản hiện tại, vui lòng đổi mật khẩu khác.',
                        style: TextStyle(color: AppColors.errorRed),
                      )
                    else
                      Text(
                        'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt',
                        style: TextStyle(color: AppColors.errorRed),
                      )
                  else if (valueNotChanged)
                    Text(
                      'Bạn đã dùng tên người dùng này cho tài khoản hiện tại, vui lòng đổi tên người dùng khác.',
                      style: TextStyle(color: AppColors.errorRed),
                    )
                  else
                    Text(
                      'Tên người dùng không được để trống.',
                      style: TextStyle(color: AppColors.errorRed),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmailVerificationDialog extends StatefulWidget {
  const EmailVerificationDialog({
    super.key,
    required this.cubit,
    required this.newEmail,
  });

  final AccountCubit cubit;
  final String newEmail;

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
        if (!context.mounted) return;
        Navigator.of(context).pop();
        return;
      }

      setState(() {
        _secondsRemaining--;
      });

      await widget.cubit.checkChangeEmailVerified(widget.newEmail);
      if (widget.cubit.state.user.email == widget.newEmail) {
        _timer?.cancel();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text(
                'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      'LoginScreen.route',
                      (route) => false,
                    );
                    widget.cubit.state.user.provider == 'password'
                        ? Navigator.of(
                          context,
                        ).pushNamed(LoginWithEmailScreen.route)
                        : null;
                  },
                  child: Text('Đăng nhập lại'),
                ),
              ],
            );
          },
        );
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
            "Chúng tôi đã gửi email xác nhận đến email ${widget.newEmail}, vui lòng nhấp vào liên kết trong email để xác minh email (email xác nhận có hiệu lực trong $_secondsRemaining).",
          ),
          SizedBox(height: 16),
          _secondsRemaining <= 0
              ? Center(child: Text('Vui lòng thử lại!'))
              : CircularProgressIndicator(),
        ],
      ),
      actions: [
        _secondsRemaining == 0
            ? TextButton(
              onPressed: () {
                widget.cubit.changeEmail(widget.newEmail);
              },
              child: Text("Gửi lại email xác minh"),
            )
            : Text('Gửi lại email xác minh'),
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).pop();
          },
          child: Text("Đóng"),
        ),
      ],
    );
  }
}
