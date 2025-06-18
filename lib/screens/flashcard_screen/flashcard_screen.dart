import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/widgets/button/text_to_speech_button.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  static const String route = "FlashcardScreen";

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int left = 0;
  int right = 0;
  int isLearned = 0;
  final words = [
    {'hello': 'xin chào'},
    {'goodbye': 'tạm biệt'},
    {'thank you': 'cảm ơn'},
    {'sorry': 'xin lỗi'},
    {'yes': 'vâng'},
    {'no': 'không'},
  ];
  late Offset position;
  late Offset initialPosition;
  late double width, height;
  int curr = 0;
  double opacity = 0;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      initialPosition = Offset(size.width * 3 / 26, 32);
      position = initialPosition;
      width = size.width / 1.3;
      height = size.height / 1.5;
      setState(() {
        isInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    // double screenHeight = MediaQuery.sizeOf(context).height;
    Map<String, String> word = words[curr];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text('data', style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.settings))
        ],
        actionsPadding: EdgeInsets.only(right: 8),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 4,
              width: screenWidth / 2,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLearned != -1
                  ? Container(
                    width: 50,
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withAlpha(50),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border(
                        top: BorderSide(color: AppColors.warningOrange),
                        right: BorderSide(color: AppColors.warningOrange),
                        bottom: BorderSide(color: AppColors.warningOrange),
                      ),
                    ),
                    child: Text('$left'),
                  )
                  : Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 50,
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: AppColors.warningOrange,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        '+1',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              isLearned != 1
                  ? Container(
                    width: 50,
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withAlpha(50),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      border: Border(
                        top: BorderSide(color: AppColors.successGreen),
                        left: BorderSide(color: AppColors.successGreen),
                        bottom: BorderSide(color: AppColors.successGreen),
                      ),
                    ),
                    child: Text('$right'),
                  )
                  : Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 50,
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        '+1',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          Expanded(
            child:
                isInitialized
                    ? Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 100),
                          top: position.dy,
                          left: position.dx,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                position += details.delta;
                                if (position.dx - initialPosition.dx < 0) {
                                  isLearned = -1;
                                } else {
                                  isLearned = 1;
                                }
                                double moveDistance =
                                    (position.dx - initialPosition.dx).abs();
                                double maxDistance = width / 2;
                                opacity = (moveDistance / maxDistance).clamp(
                                  0.0,
                                  1.0,
                                );
                              });
                            },
                            onPanEnd: (_) {
                              setState(() {
                                if (position.dx < 0) {
                                  left++;
                                  curr++;
                                }
                                if (position.dx + width > screenWidth) {
                                  right++;
                                  curr++;
                                }
                                if (curr >= words.length) {
                                  curr = 0;
                                }
                                position = initialPosition;
                                if (position.dx - initialPosition.dx == 0) {
                                  isLearned = 0;
                                }
                                opacity = 0;
                              });
                            },
                            child: Transform.rotate(
                              angle: (position.dx - initialPosition.dx) / 3600,
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 1 - opacity,
                                    child: FlipCard(
                                      fill: Fill.fillBack,
                                      front: Container(
                                        padding: EdgeInsets.all(16),
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: AppColors.darkWhite,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color: AppColors.secondaryGray,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextToSpeechButton(text : word.keys.first),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.star_border),
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                word.keys.first,
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      back: Container(
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: AppColors.darkWhite,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color: AppColors.secondaryGray,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            word.values.first,
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  isLearned == 1
                                      ? Opacity(
                                        opacity: opacity,
                                        child: _learnedContainer(width, height),
                                      )
                                      : isLearned == -1
                                      ? Opacity(
                                        opacity: opacity,
                                        child: _notLearnedContainer(
                                          width,
                                          height,
                                        ),
                                      )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : SizedBox(),
          ),
          Center(child: IconButton(onPressed: (){
            setState(() {
              if(curr > 0) {
                curr--;
              }
            });
          }, icon: Icon(Icons.keyboard_return)),),
          SizedBox(height: 16,)
        ],
      ),
    );
  }

  Widget _learnedContainer(double width, double height) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.successGreen.withAlpha(100),
        border: Border.all(color: AppColors.successGreen),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Learned',
              style: TextStyle(fontSize: 30, color: AppColors.successGreen),
            ),
            SizedBox(height: 16),
            Text(
              '',
              style: TextStyle(fontSize: 30, color: AppColors.successGreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notLearnedContainer(double width, double height) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withAlpha(100),
        border: Border.all(color: AppColors.warningOrange),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Not Learned',
              style: TextStyle(fontSize: 30, color: AppColors.warningOrange),
            ),
            SizedBox(height: 16),
            Text(
              '',
              style: TextStyle(fontSize: 30, color: AppColors.successGreen),
            ),
          ],
        ),
      ),
    );
  }
}
