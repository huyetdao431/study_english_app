import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/screens/card_merge_screen/card_merge_screen.dart';
import 'package:study_english_app/screens/course_detail/cubit/course_detail_cubit.dart';
import 'package:study_english_app/screens/exam_screen/exam_screen.dart';
import 'package:study_english_app/screens/flashcard_screen/flashcard_screen.dart';
import 'package:study_english_app/screens/study_screen/study_screen.dart';
import 'package:study_english_app/widgets/button/text_to_speech_button.dart';

import '../../core/color.dart';
import '../../core/text.dart';
import '../../models/word.dart';
import '../../services/api.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  static const String route = "CourseDetailScreen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseDetailCubit(context.read<Api>()),
      child: Page(courseId: courseId),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.courseId});

  final String courseId;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseDetailCubit>().fetchCourseDetail(
        widget.courseId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailCubit, CourseDetailState>(
      builder: (context, state) {
        var cubit = context.read<CourseDetailCubit>();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body:
              cubit.state.loadStatus == LoadStatus.Loading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        WordCarousel(words: cubit.state.words),
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  cubit.state.courseName.isNotEmpty
                                      ? cubit.state.courseName
                                      : "Tên khóa học",
                                  style: AppTextStyles.headline,
                                ),
                              ),
                              SizedBox(height: 16),

                              cubit.state.username.isNotEmpty
                                  ? Row(
                                    children: [
                                      cubit.state.userImageUrl.isNotEmpty
                                          ? CircleAvatar(
                                            radius: 18,
                                            backgroundImage: AssetImage(
                                              cubit.state.userImageUrl,
                                            ),
                                          )
                                          : Container(
                                            height: 36,
                                            width: 36,
                                            decoration: BoxDecoration(
                                              color: AppColors.successGreen,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      SizedBox(width: 8),
                                      Text(
                                        cubit.state.username.isNotEmpty
                                            ? cubit.state.username
                                            : "Người tạo",
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      SizedBox(width: 24),
                                      Text(
                                        '${cubit.state.numberOfWords} thuật ngữ',
                                        style: AppTextStyles.bold,
                                      ),
                                    ],
                                  )
                                  : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${cubit.state.numberOfWords} thuật ngữ',
                                      style: AppTextStyles.bold,
                                    ),
                                  ),
                              SizedBox(height: 32),
                              MiniGameNavigatorLabel(),
                              SizedBox(height: 32),
                              Card(words: cubit.state.words),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}

class WordCarousel extends StatefulWidget {
  const WordCarousel({super.key, required this.words});

  final List<Word> words;

  @override
  State<WordCarousel> createState() => _WordCarouselState();
}

class _WordCarouselState extends State<WordCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return Center(
        child: Text(
          "Không có từ nào trong danh sách",
          style: AppTextStyles.bodySmall,
        ),
      );
    }
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          carouselController: _controller,
          items:
              widget.words.map((ele) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              ele.word,
                              style: AppTextStyles.headline,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: TextToSpeechButton(text: ele.word),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
        ),
        SizedBox(height: 12),
        _buildDots(),
      ],
    );
  }

  Widget _buildDots() {
    final int totalDots = widget.words.length;
    final int maxVisibleDots = 7;

    List<Widget> visibleDots = [];

    if (totalDots <= maxVisibleDots) {
      // Nếu số chấm ít, hiển thị hết
      for (int i = 0; i < totalDots; i++) {
        visibleDots.add(_buildDot(i));
      }
    } else {
      // Nếu nhiều chấm, chỉ hiển thị 1 đoạn (có cuộn)
      int start = (_current - maxVisibleDots ~/ 2).clamp(0, totalDots - maxVisibleDots);
      int end = (start + maxVisibleDots).clamp(0, totalDots);

      for (int i = start; i < end; i++) {
        visibleDots.add(_buildDot(i));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: visibleDots,
    );
  }

  Widget _buildDot(int i) {
    return GestureDetector(
      onTap: () => _controller.animateToPage(i),
      child: Container(
        height: 8,
        width: 8,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _current == i ? AppColors.primaryDark : AppColors.secondaryGray,
        ),
      ),
    );
  }

}

class MiniGameNavigatorLabel extends StatelessWidget {
  const MiniGameNavigatorLabel({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<CourseDetailCubit, CourseDetailState>(
      builder: (context, state) {
        var cubit = context.read<CourseDetailCubit>();
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: width,
              height: 50,
              child: NavigatorButton(
                title: "Thẻ ghi nhớ",
                onPressed: () async{
                  Navigator.of(context).pushNamed(
                    FlashcardScreen.route,
                    arguments: {'words': state.words},
                  );
                  await cubit.addCourseToUser(state.courseId);
                },
                icon: Icon(
                  Icons.file_copy,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: width,
              height: 50,
              child: NavigatorButton(
                title: "Học",
                onPressed: () async{
                  Navigator.of(context).pushNamed(
                    StudyScreen.route,
                    arguments: {'words': state.words},
                  );
                  await cubit.addCourseToUser(state.courseId);
                },
                icon: Icon(
                  Icons.file_copy,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: width,
              height: 50,
              child: NavigatorButton(
                title: "Ghép thẻ",
                onPressed: () async{
                  Navigator.of(context).pushNamed(
                    CardMergeScreen.route,
                    arguments: {'words': state.words},
                  );
                  await cubit.addCourseToUser(state.courseId);
                },
                icon: Icon(
                  Icons.file_copy,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: width,
              height: 50,
              child: NavigatorButton(
                title: "Kiểm tra",
                onPressed: () async{
                  Navigator.of(context).pushNamed(
                    ExamScreen.route,
                    arguments: {'words': state.words},
                  );
                  await cubit.addCourseToUser(state.courseId);
                },
                icon: Icon(
                  Icons.file_copy,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class NavigatorButton extends StatelessWidget {
  const NavigatorButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
  });

  final String title;
  final VoidCallback onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadowColor: AppColors.secondaryGray,
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        children: [
          icon ?? Container(),
          icon != null ? SizedBox(width: 8) : Container(),
          Text(title, style: AppTextStyles.bold),
        ],
      ),
    );
  }
}

class Card extends StatefulWidget {
  const Card({super.key, required this.words});

  final List<Word> words;

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  String sortBy = 'Thứ tự gốc';
  List<Word> orderedWords = [];

  @override
  Widget build(BuildContext context) {
    if (sortBy == 'Thứ tự gốc') {
      orderedWords = widget.words;
    }
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Text('Thẻ', style: AppTextStyles.headline)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(sortBy, style: AppTextStyles.bodySmall),
                SizedBox(width: 12),
                PopupMenuButton(
                  icon: Icon(Icons.filter_list, color: AppColors.primaryDark),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'sort_by_name',
                        child: ListTile(
                          trailing:
                              sortBy == 'Sắp xếp theo tên'
                                  ? Icon(
                                    Icons.check,
                                    color: AppColors.primaryDark,
                                  )
                                  : null,
                          title: Text('Sắp xếp theo tên'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'original',
                        child: ListTile(
                          trailing:
                              sortBy == 'Thứ tự gốc'
                                  ? Icon(
                                    Icons.check,
                                    color: AppColors.primaryDark,
                                  )
                                  : null,
                          title: Text('Thứ tự gốc'),
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'sort_by_name') {
                      orderedWords =
                          widget.words
                              .where((word) => word.word.isNotEmpty)
                              .toList()
                            ..sort((a, b) => a.word.compareTo(b.word));
                      setState(() {
                        sortBy = 'Sắp xếp theo tên';
                      });
                    } else if (value == 'original') {
                      orderedWords = widget.words;
                      setState(() {
                        sortBy = 'Thứ tự gốc';
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        for (var word in orderedWords)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondaryGray, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(word.word, style: AppTextStyles.title),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(word.meaning),
                      ),
                    ],
                  ),
                ),
                TextToSpeechButton(text: word.word),
              ],
            ),
          ),
      ],
    );
  }
}
