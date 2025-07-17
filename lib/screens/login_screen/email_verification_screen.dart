import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/screens/login_screen/cubit/login_cubit.dart';

import '../../services/api.dart';
import 'login_with_email.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  static const String route = "EmailVerificationScreen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<Api>()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please verify your email address",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20, width: double.infinity,),
                  ElevatedButton(
                    onPressed: () async {
                      // await cubit.emailVerification();
                      if(!context.mounted) return;
                      state.isVerified
                          ? Navigator.of(context).pushReplacementNamed(LoginWithEmailScreen.route)
                          : showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Verification Failed"),
                                content: const Text("Please try again later."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                    },
                    child: const Text("Send Verification Email"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
