import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/screens/add_course_screen/add_course_screen.dart';
import 'package:study_english_app/screens/course_detail/course_detail_screen.dart';
import 'package:study_english_app/screens/library_screen/cubit/library_cubit.dart';
import 'package:study_english_app/services/api.dart';

import '../../common/enum/load_status.dart';
import '../../core/color.dart';
import '../../core/text.dart';

class LibraryScreen extends StatelessWidget {
  static const String route = "LibraryScreen";

  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryCubit(context.read<Api>()),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryCubit>().fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thư viện'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddCourseScreen.route,
                  arguments: {"isAddCourse": true, "courseId": ''},
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            tabs: [Tab(text: 'Khóa học đã học'), Tab(text: 'Thư viện của tôi')],
          ),
        ),
        body: TabBarView(children: [LearnedCoursePage(), MyLibrary()]),
      ),
    );
  }
}

class LearnedCoursePage extends StatelessWidget {
  const LearnedCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        final cubit = context.read<LibraryCubit>();

        if (cubit.state.loadStatus == LoadStatus.Loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = groupCoursesByTime(cubit.state.learnedCourses);

        // Sắp xếp nhóm theo thời gian gần nhất
        final sortedKeys =
            [
              "Hôm nay",
              "1 ngày trước",
              "2 ngày trước",
              "3 ngày trước",
              "4 ngày trước",
              "5 ngày trước",
              "6 ngày trước",
              "1 tuần trước",
              "2 tuần trước",
              "3 tuần trước",
              "1 tháng trước",
              "2 tháng trước",
              "Trước đó",
            ].where((key) => grouped.containsKey(key)).toList();

        return RefreshIndicator(
          onRefresh: () async {
            await cubit.fetchCourses();
          },
          child: ListView.builder(
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final groupName = sortedKeys[index];
              final courses = grouped[groupName]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      groupName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...courses.map(
                    (course) => CourseCard(
                      course: course,
                      popUpMenuItem: Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'delete',
                                child: Text("Xóa khỏi khóa học đã học"),
                              ),
                            ];
                          },
                          onSelected: (value) async {
                            if (value == 'delete') {
                              await cubit.removeUserFromCourse(
                                course['course'].id,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> groupCoursesByTime(
    List<Map<String, dynamic>> learnedCourses,
  ) {
    final now = DateTime.now();
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final entry in learnedCourses) {
      final course = entry;
      final learnedAt = entry['latestLearn'];
      final diff = now.difference(learnedAt);

      String group;

      if (diff.inDays == 0) {
        group = "Hôm nay";
      } else if (diff.inDays == 1) {
        group = "1 ngày trước";
      } else if (diff.inDays <= 6) {
        group = "${diff.inDays} ngày trước";
      } else if (diff.inDays <= 13) {
        group = "1 tuần trước";
      } else if (diff.inDays <= 20) {
        group = "2 tuần trước";
      } else if (diff.inDays <= 27) {
        group = "3 tuần trước";
      } else if (diff.inDays <= 60) {
        group = "1 tháng trước";
      } else if (diff.inDays <= 90) {
        group = "2 tháng trước";
      } else {
        group = "Trước đó";
      }

      grouped.putIfAbsent(group, () => []).add(course);
    }

    return grouped;
  }
}

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        var cubit = context.read<LibraryCubit>();

        return cubit.state.loadStatus == LoadStatus.Loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
              onRefresh: () async {
                await cubit.fetchCourses();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: const Text(
                        'Khóa học của tôi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          cubit.state.userCourses
                              .map(
                                (item) => CourseCard(
                                  course: item,
                                  popUpMenuItem: Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton(
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text("Chỉnh sửa"),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text("Xóa"),
                                          ),
                                          PopupMenuItem(
                                            value: 'isPublic',
                                            child: Text(
                                              "Trạng thái: ${item['course'].isPublic ? 'Công khai' : 'Riêng tư'}",
                                            ),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) async {
                                        if (value == 'edit') {
                                          Navigator.of(context).pushNamed(
                                            AddCourseScreen.route,
                                            arguments: {
                                              'courseId': item['course'].id,
                                              'isAddCourse': false,
                                            },
                                          );
                                        } else if (value == 'delete') {
                                          await cubit.deleteCourse(
                                            item['course'].id,
                                          );
                                        } else if (value == 'isPublic') {
                                          if (item['course'].isPublic) {
                                            await cubit.setPublicCourse(
                                              item['course'].id,
                                              false,
                                            );
                                          } else {
                                            await cubit.setPublicCourse(
                                              item['course'].id,
                                              true,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final Widget popUpMenuItem;

  const CourseCard({
    super.key,
    required this.course,
    required this.popUpMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CourseDetailScreen.route,
                    arguments: {'courseId': course['course'].id},
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.lightGray, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          course['course'].name,
                          style: AppTextStyles.title,
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${course['course'].words.length} thuật ngữ',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                course['avt'].isNotEmpty
                                    ? CircleAvatar(
                                      radius: 18,
                                      backgroundImage: AssetImage(
                                        course['avt'],
                                      ),
                                    )
                                    : Container(
                                      alignment: Alignment.center,
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.darkWhite,
                                      ),
                                      child: Text(
                                        course['username'][0].toUpperCase(),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                SizedBox(width: 8),
                                Text(
                                  course['username'],
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          popUpMenuItem,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class MyLibrary extends StatefulWidget {
//   const MyLibrary({super.key});
//
//   @override
//   State<MyLibrary> createState() => _MyLibraryState();
// }
//
// class _MyLibraryState extends State<MyLibrary>
//     with SingleTickerProviderStateMixin {
//   bool _showList = false;
//   late AnimationController _arrowAnimationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _arrowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _arrowAnimationController.dispose();
//     super.dispose();
//   }
//
//   void _toggleList() {
//     setState(() {
//       _showList = !_showList;
//       if (_showList) {
//         _arrowAnimationController.forward();
//       } else {
//         _arrowAnimationController.reverse();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LibraryCubit, LibraryState>(
//       builder: (context, state) {
//         var cubit = context.read<LibraryCubit>();
//
//         return cubit.state.loadStatus == LoadStatus.Loading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   GestureDetector(
//                     onTap: _toggleList,
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         children: [
//                           const Text(
//                             'Khóa học của tôi',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           AnimatedBuilder(
//                             animation: _arrowAnimationController,
//                             builder: (_, child) {
//                               return Transform.rotate(
//                                 angle: _arrowAnimationController.value * 3.14,
//                                 child: child,
//                               );
//                             },
//                             child: const Icon(Icons.expand_more),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Danh sách với hiệu ứng rõ dần và trượt xuống
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     switchInCurve: Curves.easeOut,
//                     switchOutCurve: Curves.easeIn,
//                     transitionBuilder: (child, animation) {
//                       final offsetAnimation = Tween<Offset>(
//                         begin: const Offset(0, -0.05), // từ trên xuống
//                         end: Offset.zero,
//                       ).animate(animation);
//
//                       return FadeTransition(
//                         opacity: animation,
//                         child: SlideTransition(
//                           position: offsetAnimation,
//                           child: child,
//                         ),
//                       );
//                     },
//                     child:
//                         _showList
//                             ? Container(
//                               padding: const EdgeInsets.only(bottom: 8),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children:
//                                     cubit.state.userCourses
//                                         .map(
//                                           (item) => CourseCard(
//                                             course: item.keys.first,
//                                               popUpMenuItem:  Align(
//                                                 alignment: Alignment.centerRight,
//                                                 child: PopupMenuButton(
//                                                   itemBuilder: (context) {
//                                                     return [
//                                                       PopupMenuItem(
//                                                         value: 'edit',
//                                                         child: Text("Chỉnh sửa"),
//                                                       ),
//                                                       PopupMenuItem(
//                                                         value: 'delete',
//                                                         child: Text("Xóa"),
//                                                       ),
//                                                     ];
//                                                   },
//                                                   onSelected: (value) async {
//                                                     if (value == 'edit') {
//                                                       Navigator.of(context).pushNamed(
//                                                         AddCourseScreen.route,
//                                                         arguments: {
//                                                           'courseId': item.keys.first.id,
//                                                           'isAddCourse': false,
//                                                         },
//                                                       );
//                                                     } else if (value == 'delete') {
//                                                       await cubit.deleteCourse(item.keys.first.id);
//                                                     }
//                                                   },
//                                                 ),
//                                               )
//                                           ),
//                                         )
//                                         .toList(),
//                               ),
//                             )
//                             : const SizedBox(),
//                   ),
//                 ],
//               ),
//             );
//       },
//     );
//   }
// }
