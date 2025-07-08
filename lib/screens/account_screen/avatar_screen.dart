import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';
import 'package:study_english_app/screens/account_screen/image_preview_screen.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  static const String route = "AvatarScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avatar'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          var cubit = context.read<AccountCubit>();
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 16, // Assuming you have 12 avatars
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ImagePreviewScreen.route,
                      arguments: {'cubit': cubit, 'index': index});
                },
                child: Hero(
                  tag: 'avatar_$index',
                  child: Image.asset(
                    index + 1 < 10
                        ? 'assets/images/avt0${index + 1}.png'
                        : 'assets/images/avt${index + 1}.png',
                    fit: BoxFit.cover,
                  ),
                )
                ,
              );
            },
          );
        },
      ),
      // body: ListView(
      //   children: [
      //     for (int i = 1; i <= 10; i++)
      //       ListTile(
      //         leading: CircleAvatar(
      //           backgroundImage: i < 10 ? AssetImage('assets/images/avt0$i.png') : AssetImage('assets/images/avt$i.png'),
      //         ),
      //         title: Text('Avatar $i'),
      //         onTap: () {
      //           // Handle avatar selection
      //           print('Selected Avatar $i');
      //         },
      //       ),

      //   ],
      // ),
    );
  }
}
