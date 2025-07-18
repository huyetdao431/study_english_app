
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/widgets/button/text_to_speech_button.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

import '../../models/word.dart';

class FlashcardScreen extends StatefulWidget {
  final List<Word> words;

  const FlashcardScreen({super.key, required this.words});

  static const String route = "FlashcardScreen";

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  int isLearned = 0;
  late Offset position;
  late Offset initialPosition;
  late double width, height;
  int curr = 0;
  double opacity = 0;
  bool isInitialized = false;
  bool isSweepingAway = false;
  bool isFront = true;
  List<Map<int, bool>> wordStatus = [];
  int learnedCount = 0;
  bool isFrontSideWord = true;
  bool isShuffle = false;

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
    Word word =
        curr < widget.words.length ? widget.words[curr] : widget.words[0];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text(
          '${curr == widget.words.length ? curr : curr + 1}/${widget.words.length}',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          curr < widget.words.length
              ? IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                SwitchListTile(
                                  title: Text('Trộn thẻ'),
                                  value: isShuffle,
                                  onChanged: (value) {
                                    setState(() {
                                      isShuffle = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Đổi mặt thẻ'),
                                  subtitle: Text(isFrontSideWord ? 'Mặt trước là từ, mặt sau là nghĩa' : 'Mặt trước là nghĩa, mặt sau là từ'),
                                  value: isFrontSideWord, // Replace with actual state
                                  onChanged: (value) {
                                    setState(() {
                                      isFrontSideWord = value;
                                    });
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    _clearData();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Đặt lại thẻ ghi nhớ',
                                    style: TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                icon: Icon(Icons.settings),
              )
              : SizedBox(),
        ],
      ),
      body:
          curr < widget.words.length
              ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 4,
                      width: screenWidth / widget.words.length * curr,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child:
                        isInitialized
                            ? Stack(
                              children: [
                                Positioned(
                                  top: initialPosition.dy,
                                  left: initialPosition.dx,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    height: height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: AppColors.darkWhite,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: AppColors.secondaryGray,
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: Duration(
                                        milliseconds: isSweepingAway ? 200 : 1,
                                      ),
                                      top: position.dy,
                                      left: position.dx,
                                      child: GestureDetector(
                                        onPanUpdate: (details) {
                                          setState(() {
                                            position += details.delta;
                                            if (position.dx -
                                                    initialPosition.dx <
                                                0) {
                                              isLearned = -1;
                                            } else {
                                              isLearned = 1;
                                            }
                                            double moveDistance =
                                                (position.dx -
                                                        initialPosition.dx)
                                                    .abs();
                                            double maxDistance = width / 2;
                                            opacity = (moveDistance /
                                                    maxDistance)
                                                .clamp(0.0, 1.0);
                                          });
                                        },
                                        onPanEnd: (_) async {
                                          double deltaX =
                                              position.dx - initialPosition.dx;
                                          double threshold = width * 0.25;

                                          if (deltaX.abs() > threshold) {
                                            setState(() {
                                              isSweepingAway = true;
                                              position = Offset(
                                                deltaX > 0
                                                    ? screenWidth + 100
                                                    : -width - 100,
                                                position.dy,
                                              );
                                              if (cardKey
                                                      .currentState
                                                      ?.isFront ==
                                                  false) {
                                                isFrontSideWord ? isFront = false : isFront = true;
                                              } else {
                                                isFrontSideWord ? isFront = true : isFront = false;
                                              }
                                            });

                                            await Future.delayed(
                                              Duration(milliseconds: 200),
                                            );

                                            setState(() {
                                              if (curr < widget.words.length) {
                                                curr++;
                                              }
                                              wordStatus.add({
                                                curr: isLearned == 1
                                                    ? true
                                                    : false,
                                              });
                                              if(isLearned == 1) {
                                                learnedCount++;
                                              }

                                              position = initialPosition;
                                              isSweepingAway = false;
                                              isLearned = 0;
                                              opacity = 0;
                                            });
                                          } else {
                                            setState(() {
                                              position = initialPosition;
                                              isLearned = 0;
                                              opacity = 0;
                                            });
                                          }
                                        },
                                        child: Transform.rotate(
                                          angle:
                                              (position.dx -
                                                  initialPosition.dx) /
                                              3600,
                                          child: Stack(
                                            children: [
                                              Opacity(
                                                opacity: 1 - opacity,
                                                child: FlipCard(
                                                  key: cardKey,
                                                  fill: Fill.fillBack,
                                                  front:
                                                      isFront
                                                          ? _front(
                                                            width,
                                                            height,
                                                            word,
                                                          )
                                                          : _back(
                                                            width,
                                                            height,
                                                            word,
                                                          ),
                                                  back:
                                                      isFront
                                                          ? _back(
                                                            width,
                                                            height,
                                                            word,
                                                          )
                                                          : _front(
                                                            width,
                                                            height,
                                                            word,
                                                          ),
                                                ),
                                              ),
                                              isLearned == 1
                                                  ? Opacity(
                                                    opacity: opacity,
                                                    child: _learnedContainer(
                                                      width,
                                                      height,
                                                    ),
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
                                ),
                              ],
                            )
                            : SizedBox(),
                  ),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (curr > 0) {
                            curr--;
                            wordStatus.last.values.first
                                ? learnedCount--
                                : learnedCount;
                            wordStatus.removeLast();
                          }
                        });
                      },
                      icon: Icon(Icons.keyboard_return),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              )
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tiến trình ôn tập',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircularPercentIndicator(
                            radius: 72,
                            lineWidth: 12,
                            percent: learnedCount / widget.words.length,
                            center: Text(
                              '${(learnedCount / widget.words.length * 100).ceil()}%',
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.successGreen,
                              ),
                            ),
                            reverse: true,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: AppColors.successGreen,
                            backgroundColor: AppColors.warningOrange.withAlpha(200),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.successGreen,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Đã học',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '$learnedCount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: screenWidth / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.warningOrange.withAlpha(200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Chưa học',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '${widget.words.length - learnedCount}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          curr--;
                          wordStatus.removeLast();
                        });
                      },
                      child: Text(
                        'Quay lại từ cuối cùng',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        List<Word> notLearnedWords = wordStatus
                            .where((status) => !status.values.first)
                            .map((status) => widget.words[status.keys.first-1])
                            .toList();
                        if(notLearnedWords.isNotEmpty) {
                          Navigator.of(context).pushReplacementNamed(FlashcardScreen.route, arguments: {'words': notLearnedWords});
                        } else {
                          showMyDialog(context, 'Thông báo', 'Bạn đã học hết toàn bộ từ vựng.');
                        }
                      },
                      child: Text(
                        'Tiếp tục ôn tập',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _clearData();
                        });
                      },
                      child: Text(
                        'Đặt lại thẻ nhớ',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
  void _clearData() {
    setState(() {
      wordStatus.clear();
      curr = 0;
      position = initialPosition;
      isLearned = 0;
      opacity = 0;
      isSweepingAway = false;
      learnedCount = 0;
      if(isShuffle){
        widget.words.shuffle();
      }
      if(isFrontSideWord) {
        isFront = true;
      } else {
        isFront = false;
      }
    });
  }

  Widget _front(double width, double height, Word word) {
    return Container(
      padding: EdgeInsets.all(16),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.darkWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondaryGray),
      ),
      child: Stack(
        children: [
          TextToSpeechButton(text: word.word),
          Align(
            alignment: Alignment.center,
            child: Text(
              word.word,
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _back(double width, double height, Word word) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.darkWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondaryGray),
      ),
      child: Center(
        child: Text(
          word.meaning,
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
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
