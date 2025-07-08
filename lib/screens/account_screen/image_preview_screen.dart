import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/screens/account_screen/cubit/account_cubit.dart';

import '../../common/enum/load_status.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key, required this.index});

  static const String route = "ImagePreviewScreen";

  final int index;

  String get imagePath {
    return index + 1 < 10
        ? 'assets/images/avt0${index + 1}.png'
        : 'assets/images/avt${index + 1}.png';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        var cubit = context.read<AccountCubit>();
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            backgroundColor: AppColors.black,
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text('Đặt làm ảnh đại diện'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Xác nhận'),
                              content: Text(
                                'Bạn có chắc muốn đặt ảnh này làm ảnh đại diện?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  // Đóng dialog
                                  child: Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Thực hiện hành động đặt làm ảnh đại diện
                                    await cubit.changeAvatar(imagePath);
                                    if(!context.mounted) return; // Kiểm tra nếu context còn hợp lệ
                                    if (cubit.state.loadStatus ==
                                        LoadStatus.Success) {
                                      Navigator.pop(context); // Đóng dialog
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Đã đặt làm ảnh đại diện',
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Lỗi khi đặt ảnh đại diện',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Xác nhận'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ];
                },
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () => Navigator.pop(context), // Tap để quay lại
            child: Center(
              child: Hero(
                tag: 'avatar_$index',
                child: PhotoView(
                  imageProvider: AssetImage(imagePath),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
