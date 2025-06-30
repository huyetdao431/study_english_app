import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/widgets/text/edit_text.dart';
import 'package:study_english_app/widgets/text/edit_text_with_suffix.dart';

import '../../services/api.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static const String route = 'EditProfileScreen';

  void _showEditDialog(
    BuildContext context,
    String title,
    String hint,
    void Function(String) onSave,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Change $title'),
            content:
                title == 'Password'
                    ? editTextWithSuffix(
                      'Mật khẩu mới',
                      controller,
                      () {},
                      () {},
                    )
                    : editText(title, controller, () {}, () {}),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(context.read<Api>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            var cubit = context.read<AccountCubit>();
            return ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Change Username'),
                  onTap:
                      () => _showEditDialog(
                        context,
                        'Username',
                        'Enter new username',
                        (value) {
                          // Handle username change
                        },
                      ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Change Email'),
                  onTap:
                      () => _showEditDialog(
                        context,
                        'Email',
                        'Enter new email',
                        (value) {
                          // Handle email change
                        },
                      ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap:
                      () => _showEditDialog(
                        context,
                        'Password',
                        'Enter new password',
                        (value) {
                          // Handle password change
                        },
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
