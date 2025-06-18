import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:study_english_app/screens/flashcard_screen/flashcard_screen.dart';

import '../../core/color.dart';
import '../../core/text.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});
  static const String route = "CourseDetailScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            WordCarousel(),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Course name", style: AppTextStyles.headline),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("Username", style: AppTextStyles.bodySmall),
                      SizedBox(width: 24),
                      Text("12 thuat ngu", style: AppTextStyles.bold),
                    ],
                  ),
                  SizedBox(height: 32),
                  MiniGameNavigatorLabel(),
                  SizedBox(height: 32),
                  Card(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordCarousel extends StatefulWidget {
  const WordCarousel({super.key});

  @override
  State<WordCarousel> createState() => _WordCarouselState();
}

class _WordCarouselState extends State<WordCarousel> {
  static const words = ['hello', 'hi', 'goodbye'];
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
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
          words.map((ele) {
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
                        child: Text(ele, style: AppTextStyles.headline),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.volume_up_outlined),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:
          words.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                height: 8,
                width: 8,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                  _current == entry.key
                      ? AppColors.primaryDark
                      : AppColors.secondaryGray,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MiniGameNavigatorLabel extends StatelessWidget {
  const MiniGameNavigatorLabel({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: width,
          height: 50,
          child: NavigatorButton(
            title: "Thẻ ghi nhớ",
            onPressed: () {
              Navigator.of(context).pushNamed(FlashcardScreen.route);
            },
            icon: Icon(Icons.file_copy, color: AppColors.primaryDark, size: 30),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: width,
          height: 50,
          child: NavigatorButton(
            title: "Học",
            onPressed: () {},
            icon: Icon(Icons.file_copy, color: AppColors.primaryDark, size: 30),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: width,
          height: 50,
          child: NavigatorButton(
            title: "flashcard",
            onPressed: () {},
            icon: Icon(Icons.file_copy, color: AppColors.primaryDark, size: 30),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: width,
          height: 50,
          child: NavigatorButton(
            title: "flashcard",
            onPressed: () {},
            icon: Icon(Icons.file_copy, color: AppColors.primaryDark, size: 30),
          ),
        ),
        SizedBox(height: 12),
      ],
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

class Card extends StatelessWidget {
  const Card({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Text('Thẻ', style: AppTextStyles.headline,)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("kiểu sắp xếp", style: AppTextStyles.bodySmall,),
                SizedBox(width: 12,),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.filter_list),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          child: DecoratedBox(decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondaryGray, width: 2),
          ), child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(alignment: Alignment.centerLeft ,child: Text("Word", style: AppTextStyles.title,)),
                      SizedBox(height: 12,),
                      Align(alignment: Alignment.centerLeft ,child: Text("Meaning")),
                    ],
                  ),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.volume_up_outlined))
              ],
            ),
          ),),
        )
      ],
    );
  }
}
