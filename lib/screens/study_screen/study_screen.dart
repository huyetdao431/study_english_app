import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/widgets/button/primary_button.dart';

import '../../models/word.dart';

class StudyScreen extends StatefulWidget {
  final List<Word> words;
  static const String route = "StudyScreen";

  const StudyScreen({super.key, required this.words});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int curr = 0;
  bool isSelected = false;
  var isOptionsSelected = [false, false, false, false];
  bool isActivated = true;
  int totalCorrect = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.words.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> question = generateQuestion(
      widget.words,
      curr < widget.words.length ? curr : 0,
    );
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close_sharp),
        ),
      ),
      body:
          curr < widget.words.length
              ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 50,
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withAlpha(125),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text('${curr + 1}'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double progressWidth = constraints.maxWidth;
                              return Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGray,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        progressWidth /
                                        widget.words.length *
                                        (curr + 1),
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColors.successGreen,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 50,
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withAlpha(125),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text('${widget.words.length}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${question['question']}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 32),
                    Expanded(
                      child: _options(
                        question['options'],
                        question['correctAnswer'],
                        () {
                          setState(() {
                            isActivated = true;
                            isOptionsSelected = [false, false, false, false];
                            if (curr < widget.words.length) {
                              curr++;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
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
                        'Kết quả',
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
                            percent: totalCorrect / widget.words.length,
                            center: Text(
                              '${totalCorrect / widget.words.length * 100}%',
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.successGreen,
                              ),
                            ),
                            reverse: true,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: AppColors.successGreen,
                            backgroundColor: AppColors.errorRed.withAlpha(200),
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
                                        'Số câu đúng',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '$totalCorrect',
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
                                  color: AppColors.errorRed.withAlpha(200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Số câu sai',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '${widget.words.length - totalCorrect}',
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
                          Navigator.of(context).pushReplacementNamed(
                            StudyScreen.route,
                            arguments: {'words': widget.words},
                          );
                        });
                      },
                      child: Text(
                        'Làm lại',
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

  Widget _options(
    List<String> options,
    String correctAnswer,
    VoidCallback onTap,
  ) {
    var isOptionsSelected = [false, false, false, false];
    bool isActivated = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < isOptionsSelected.length; i++)
                    isActivated
                        ? Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isOptionsSelected[i] = true;
                                isActivated = false;
                                if (options[i].compareTo(correctAnswer) == 0) {
                                  totalCorrect++;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: _option(
                              options[i].compareTo(correctAnswer) == 0,
                              options[i],
                              isOptionsSelected[i],
                            ),
                          ),
                        )
                        : Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: _option(
                            options[i].compareTo(correctAnswer) == 0,
                            options[i],

                            options[i].compareTo(correctAnswer) == 0
                                ? true
                                : isOptionsSelected[i],
                          ),
                        ),
                ],
              ),
            ),
            isActivated
                ? SizedBox()
                : SizedBox(
                  height: 80,
                  child: Center(
                    child: primaryButton(false, 'Tiếp tục', null, onTap),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _option(bool isCorrectOption, String text, bool isSelected) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
          isSelected && isCorrectOption
              ? AppColors.successGreen
              : isSelected && !isCorrectOption
              ? AppColors.errorRed
              : AppColors.lightGray,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          !isSelected ? SizedBox() : SizedBox(width: 16),
          !isSelected
              ? SizedBox()
              : isCorrectOption
              ? Icon(Icons.check, color: AppColors.successGreen)
              : Icon(Icons.close, color: AppColors.errorRed),
          SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }

  Map<String, dynamic> generateQuestion(List<Word> words, int index) {
    final random = Random();

    // 0: từ → nghĩa | 1: nghĩa → từ
    final questionType = random.nextInt(2);

    final correctWord = words[index];

    final otherItems = words.where((e) => e.word != correctWord.word).toList();

    otherItems.shuffle();
    final wrongOptions = otherItems.take(3).toList();

    List<String> options;

    if (questionType == 0) {
      // Từ → Nghĩa
      options = [...wrongOptions.map((e) => e.meaning), correctWord.meaning];
    } else {
      // Nghĩa → Từ
      options = [...wrongOptions.map((e) => e.word), correctWord.word];
    }

    options.shuffle();

    return {
      "type": questionType,
      "question": questionType == 0 ? correctWord.word : correctWord.meaning,
      "correctAnswer":
          questionType == 0 ? correctWord.meaning : correctWord.word,
      "options": options,
    };
  }
}
