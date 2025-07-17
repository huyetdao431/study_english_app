import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/widgets/others/calendar.dart';

import '../../common/enum/load_status.dart';
import '../../services/api.dart';
import 'avatar_screen.dart';
import 'settings_screen.dart';

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

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountCubit>().loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account'), centerTitle: true, elevation: 0),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          var cubit = context.read<AccountCubit>();
          return cubit.state.loadStatus == LoadStatus.Loading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AvatarScreen.route,
                                  arguments: {'cubit': cubit},
                                );
                              },
                              child: cubit.state.user.avt.isNotEmpty
                                    ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: Image.asset(cubit.state.user.avt).image,
                                )
                                    :
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkWhite,
                                    border: Border.all(color: AppColors.primaryDark, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    cubit.state.user.username.isNotEmpty
                                        ? cubit.state.user.username[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: 48,
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              cubit.state.user.username.isNotEmpty
                                  ? cubit.state.user.username
                                  : 'User',
                              style: AppTextStyles.headline,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.darkWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryDark.withAlpha(51),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.settings_outlined, size: 28,),
                          title: Text('Cài đặt của bạn', style: AppTextStyles.body),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              SettingsScreen.route,
                              arguments: {'cubit': cubit},
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.darkWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryDark.withAlpha(51),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.notifications_none, size: 28),
                          title: Text('Hoạt động', style: AppTextStyles.body),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Thành tựu', style: AppTextStyles.headline),
                      ),
                      SizedBox(height: 8),
                      calendar(double.infinity),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }
}
