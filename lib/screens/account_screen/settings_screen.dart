import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/helpers/helper_implement.dart';
import 'package:study_english_app/helpers/helpers.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/screens/account_screen/edit_user_info_screen.dart';
import 'package:study_english_app/widgets/button/button.dart';
import 'package:study_english_app/widgets/button/primary_button.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

import '../../common/enum/load_status.dart';
import '../../core/text.dart';
import '../login_screen/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String route = 'SettingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.Error) {
            showMyDialog(
              context,
              'Thông báo',
              'Đã có lỗi xảy ra, vui lòng thử lại sau!',
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  //user information
                  UserInfo(),
                  const SizedBox(height: 16),
                  //theme
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Giao diện',
                      style: AppTextStyles.title.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.lightGray, width: 2),
                    ),
                    child: ListTile(
                      title: const Text('Chủ đề'),
                      subtitle: Text('Mặc định'),
                      trailing: const Icon(Icons.navigate_next),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  //introduction
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Giới thiệu',
                      style: AppTextStyles.title.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.lightGray, width: 2),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Chính sách quyền riêng tư'),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                        const Divider(color: AppColors.lightGray),
                        ListTile(
                          title: const Text('Điểu khoản dịch vụ'),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                        const Divider(color: AppColors.lightGray),
                        ListTile(
                          title: const Text('Giấy phép mã nguồn mở'),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                        const Divider(color: AppColors.lightGray),
                        ListTile(
                          title: const Text('Trung tâm hỗ trợ'),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  //logout and delete account
                  LogoutAndDeleteAccount(),
                  //app logo and version
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withAlpha(50),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Study English App',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Phiên bản 1.0.0',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LogoutAndDeleteAccount extends StatefulWidget {
  const LogoutAndDeleteAccount({super.key});

  @override
  State<LogoutAndDeleteAccount> createState() => _LogoutAndDeleteAccountState();
}

class _LogoutAndDeleteAccountState extends State<LogoutAndDeleteAccount> {
  bool isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.Error) {
          showMyDialog(
            context,
            'Thông báo',
            'Đã có lỗi xảy ra, vui lòng thử lại sau!',
          );
        } else if (state.loadStatus == LoadStatus.Success && isConfirmed) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(LoginScreen.route, (route) => false);
        }
      },
      builder: (context, state) {
        var cubit = context.read<AccountCubit>();
        return Column(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Xóa tài khoản'),
                      content: const Text(
                        'Bạn có chắc chắn muốn xóa tài khoản của mình? Hành động này không thể hoàn tác.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await cubit.deleteAccount();
                            if (!context.mounted) return;
                            if (cubit.state.loadStatus == LoadStatus.Success) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                LoginScreen.route,
                                (route) => false,
                              );
                            } else {
                              showMyDialog(
                                context,
                                'Thông báo',
                                'Xóa tài khoản không thành công!',
                              );
                            }
                          },
                          child: const Text('Xóa'),
                        ),
                      ],
                    );
                  },
                );
              },
              highlightColor: AppColors.errorRed.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Xóa tài khoản',
                    style: AppTextStyles.body.copyWith(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Đăng xuất'),
                      content: const Text(
                        'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này không?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await cubit.logout();
                            if (!context.mounted) return;
                            if (cubit.state.loadStatus == LoadStatus.Success) {
                              setState(() {
                                isConfirmed = true;
                              });
                            }
                          },
                          child: const Text('Có'),
                        ),
                      ],
                    );
                  },
                );
                if (isConfirmed) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.route,
                    (route) => false,
                  );
                }
              },
              highlightColor: AppColors.primaryBlue.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Đăng xuất',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Helper helper = HelperImplement();
  bool canShowDialog = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = context.read<AccountCubit>();
        var width = MediaQuery.of(context).size.width;
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thông tin cá nhân',
                style: AppTextStyles.title.copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightGray, width: 2),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Tên người dùng'),
                    subtitle: Text(state.user.username),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.of(context).pushNamed(EditUserInfoScreen.route, arguments: {
                        'fieldType': 'username',
                        'cubit': cubit,
                        'oldValue': state.user.username,
                      });
                    }
                  ),
                  const Divider(color: AppColors.lightGray),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(state.user.email),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      cubit.state.user.provider == 'google.com' ? showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: double.infinity),
                                Text(
                                  'Yêu cầu đăng nhập',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Vui lòng đăng nhập lại để thay đổi email của bạn.',
                                ),
                                SizedBox(height: 20),
                                primaryButton(
                                  true,
                                  'Đăng nhập bằng google',
                                  null,
                                  () async{
                                    await cubit.reAuthenticateWithCheck();
                                    if(!context.mounted) return;
                                    if(cubit.state.isReAuthenticated) {
                                      cubit.resetReAuthenticated();
                                      Navigator.pop(context);
                                      Navigator.of(context).pushNamed(
                                        EditUserInfoScreen.route,
                                        arguments: {
                                          'fieldType': 'email',
                                          'cubit': cubit,
                                          'oldValue': '',
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Xác thực không thành công, vui lòng thử lại!'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                button(false, 'Đóng', null, () {
                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                          );
                        },
                      ) : showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          bool localObscure = true;
                          bool isPasswordValid = false;
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return AlertDialog(
                                title: Text('Xác thực tài khoản'),
                                content:
                                SizedBox(
                                  width: width * 0.8,
                                  child: Column(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Vui lòng nhập mật khẩu hiện tại của bạn để xác thực.',
                                      ),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: controller,
                                        decoration: InputDecoration(
                                          labelText:
                                          'Nhập mật khẩu hiện tại',
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setDialogState(() {
                                                localObscure =
                                                !localObscure;
                                              });
                                            },
                                            icon: Icon(
                                              localObscure
                                                  ? Icons.visibility_off : Icons.visibility,
                                            ),
                                          ),
                                        ),
                                        obscureText:
                                        localObscure,
                                      ),
                                      const SizedBox(height: 8),
                                      isPasswordValid ? Text(
                                        'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt',
                                        style: TextStyle(
                                          color: AppColors.errorRed,
                                          fontSize: 12,
                                        ),
                                      ) : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (!helper.isValidPassword(
                                        controller.text,
                                      )) {
                                        setState(() {
                                          isPasswordValid = true;
                                        });
                                        return;
                                      }
                                      await cubit.reAuthenticateWithCheck(
                                        password : controller.text,
                                      );
                                      if(cubit.state.isReAuthenticated) {
                                        cubit.resetReAuthenticated();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(
                                          EditUserInfoScreen.route,
                                          arguments: {
                                            'fieldType': 'email',
                                            'cubit': cubit,
                                            'oldValue': state.user.email,
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Xác thực không thành công, vui lòng thử lại!',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Xác nhận'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  state.user.provider == 'password'
                      ? const Divider(color: AppColors.lightGray)
                      : SizedBox(),
                  state.user.provider == 'password'
                      ? ListTile(
                        title: Text('Đổi mật khẩu'),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final controller = TextEditingController();
                              bool localObscure = true;
                              bool isPasswordValid = false;
                              return StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                        title: Text('Xác thực tài khoản'),
                                        content:
                                            SizedBox(
                                                  width: width * 0.8,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Vui lòng nhập mật khẩu hiện tại của bạn để xác thực.',
                                                      ),
                                                      SizedBox(height: 16),
                                                      TextField(
                                                        controller: controller,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Nhập mật khẩu hiện tại',
                                                          suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setDialogState(() {
                                                                localObscure =
                                                                    !localObscure;
                                                              });
                                                            },
                                                            icon: Icon(
                                                              localObscure
                                                                  ? Icons.visibility_off : Icons.visibility,
                                                            ),
                                                          ),
                                                        ),
                                                        obscureText:
                                                            localObscure,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      isPasswordValid
                                                          ? Text(
                                                              'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt',
                                                              style: TextStyle(
                                                                color: AppColors.errorRed,
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          : const SizedBox.shrink(),
                                                    ],
                                                  ),
                                                ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Hủy'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (!helper.isValidPassword(
                                                controller.text,
                                              )) {
                                                setState(() {
                                                  isPasswordValid = true;
                                                });
                                                return;
                                              }
                                              await cubit.reAuthenticateWithCheck(
                                                password : controller.text,
                                              );
                                              if(cubit.state.isReAuthenticated) {
                                                cubit.resetReAuthenticated();
                                                Navigator.pop(context);
                                                Navigator.of(context).pushNamed(
                                                  EditUserInfoScreen.route,
                                                  arguments: {
                                                    'fieldType': 'password',
                                                    'cubit': cubit,
                                                    'oldValue': controller.text,
                                                  },
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Xác thực không thành công, vui lòng thử lại!',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Xác nhận'),
                                          ),
                                        ],
                                      );
                                },
                              );
                            },
                          );
                        },
                      )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

