import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/screens/login_screen/login_screen.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

import '../../common/enum/load_status.dart';
import '../../services/api.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatelessWidget {
  static const String route = "AccountScreen";

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(context.read<Api>()),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  final String username = 'John Doe';
  final String email = 'john.doe@email.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        backgroundColor: AppColors.successGreen,
        elevation: 0,
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          var cubit = context.read<AccountCubit>();
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32),
                color: AppColors.successGreen,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.white,
                      child: Text(
                        username[0],
                        style: TextStyle(
                          fontSize: 48,
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      username,
                      style: AppTextStyles.headline.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      email,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.darkWhite,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.edit, color: AppColors.successGreen),
                title: Text('Edit Profile', style: AppTextStyles.body),
                onTap: () {
                  Navigator.of(context).pushNamed(EditProfileScreen.route);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings, color: AppColors.successGreen),
                title: Text('Settings', style: AppTextStyles.body),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: AppTextStyles.body.copyWith(color: Colors.red),
                ),
                onTap: () async {
                  await cubit.logout();
                  if (!context.mounted) return;
                  if (cubit.state.loadStatus == LoadStatus.Success) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.route,
                      (route) => false,
                    );
                  } else {
                    showMyDialog(context, 'Thông báo', 'Đăng xuất không thành công!');
                  }

                },
              ),
            ],
          );
        },
      ),
    );
  }
}
