import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:study_english_app/common/enum/load_status.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/models/word.dart';
import 'package:study_english_app/screens/exam_screen/cubit/exam_cubit.dart';
import 'package:study_english_app/widgets/button/primary_button.dart';
import 'package:study_english_app/widgets/button/switch_button_with_title.dart';
import 'package:study_english_app/widgets/others/show_dialog.dart';

class ExamScreen extends StatefulWidget {
  final List<Word> words;
  static const String route = 'ExamScreen';

  const ExamScreen({super.key, required this.words});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamCubit(),
      child: Scaffold(appBar: AppBar(), body: Page(words: widget.words)),
    );
  }
}

class Page extends StatefulWidget {
  final List<Word> words;

  const Page({super.key, required this.words});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  TextEditingController numberOfQuestionsController = TextEditingController(
    text: '0',
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        var cubit = context.read<ExamCubit>();
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child:
          !cubit.state.isExamStarted
              ? Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thiết lập bài thi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Số lượng câu hỏi (tối đa ${widget.words.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: numberOfQuestionsController,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.rtl,
                      onChanged: (value) {
                        setState(() {
                          final number = int.tryParse(value);
                          if (number != null &&
                              number > widget.words.length) {
                            numberOfQuestionsController.text =
                                widget.words.length.toString();
                            cubit.setNumberOfQuestions(number);
                          } else {
                            cubit.setNumberOfQuestions(number ?? 0);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              SwitchButtonWithTitle(
                title: 'Hiển thị đáp án ngay',
                value: cubit.state.isShowAnswer,
                onChanged: (value) {
                  setState(() {
                    cubit.setIsShowAnswer(value);
                  });
                },
              ),
              SizedBox(height: 24),
              Divider(color: AppColors.secondaryGray, thickness: 1),
              SizedBox(height: 24),
              SwitchButtonWithTitle(
                title: 'Đúng / Sai',
                value: cubit.state.isTrueOrFalse,
                onChanged: (value) {
                  setState(() {
                    cubit.setIsTrueOrFalse(value);
                  });
                },
              ),
              SizedBox(height: 24),
              SwitchButtonWithTitle(
                title: 'Nhiều lựa chọn',
                value: cubit.state.isMultipleChoice,
                onChanged: (value) {
                  setState(() {
                    cubit.setIsMultipleChoice(value);
                  });
                },
              ),
              SizedBox(height: 24),
              SwitchButtonWithTitle(
                title: 'Tự luận',
                value: cubit.state.isFillInTheBlank,
                onChanged: (value) {
                  setState(() {
                    cubit.setIsFillInTheBlank(value);
                  });
                },
              ),
              Expanded(child: SizedBox()),
              primaryButton(false, 'Bắt đầu làm bài kiểm tra', 16, () {
                setState(() {
                  cubit.setNumberOfQuestions(
                    int.tryParse(numberOfQuestionsController.text) ?? 0,
                  );
                  if (state.numberOfQuestions <= 0) {
                    showMyDialog(
                      context,
                      'Thông báo',
                      'Vui lòng nhập số lượng câu hỏi lớn hơn 0',
                    );
                  } else {
                    cubit.setIsExamStarted(true);
                  }
                });
              }),
            ],
          )
              : QuestionPage(words: widget.words),
        );
      },
    );
  }
}

class QuestionPage extends StatefulWidget {
  final List<Word> words;

  const QuestionPage({super.key, required this.words});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  void initState() {
    super.initState();
    if (context
        .read<ExamCubit>()
        .state
        .isExamStarted) {
      context.read<ExamCubit>().generateQuestions(widget.words);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        var cubit = context.read<ExamCubit>();
        var question = cubit.getCurrentQuestion();
        return state.currentQuestionIndex < cubit.state.numberOfQuestions
            ? cubit.state.loadStatus == LoadStatus.Loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: switch (question['questionType']) {
                'true_false' => TrueFalseQuestion(question: question),
                'fill_in_the_blank' =>
                    FillInTheBlank(
                      question: question,
                    ),
                'multiple_choice' => MultipleChoice(question: question),
                _ => Center(child: Text('Unknown question type')),
              },
            ),
            state.isAnswerSelected
                ? primaryButton(
              false,
              state.currentQuestionIndex ==
                  state.numberOfQuestions - 1
                  ? 'Kết thúc'
                  : 'Tiếp tục',
              16,
                  () {
                setState(() {
                  cubit.nextQuestion();
                  cubit.setIsAnswerSelected(false);
                });
              },
            )
                : Container(),
          ],
        )
            : CompleteScreen();
      },
    );
  }
}

//dung sai
class TrueFalseQuestion extends StatefulWidget {
  final Map<String, dynamic> question;

  const TrueFalseQuestion({super.key, required this.question});

  @override
  State<TrueFalseQuestion> createState() => _TrueFalseQuestionState();
}

class _TrueFalseQuestionState extends State<TrueFalseQuestion> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        var cubit = context.read<ExamCubit>();
        if (!state.isAnswerSelected) {
          isSelected = [false, false];
        }
        return Column(
          children: [
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thuật ngữ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.question['word'],
                style: TextStyle(fontSize: 18, color: AppColors.black),
              ),
            ),
            Divider(color: AppColors.secondaryGray, thickness: 1, height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Định nghĩa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.question['meaning'],
                style: TextStyle(fontSize: 18, color: AppColors.black),
              ),
            ),
            SizedBox(height: 24),

            InkWell(
              onTap:
              !state.isAnswerSelected
                  ? () {
                setState(() {
                  cubit.setIsAnswerSelected(true);
                  isSelected[0] = true;
                  if (widget.question['answer'] == true) {
                    cubit.setTotalCorrectAnswers();
                  }
                  cubit.addAnsweredQuestion({
                    'question': widget.question['word'],
                    'answer':
                    widget.question['answer'] ? 'Đúng' : 'Sai',
                    'userAnswer': 'Đúng',
                    'isCorrect': widget.question['answer'] == true,
                    'questionType': 'true_false',
                  });
                });
              }
                  : null,
              child:
              state.isShowAnswer
                  ? Option(
                text: 'Đúng',
                isSelected: isSelected[0],
                isCorrectOption: widget.question['answer'] == true,
                isShowAnswer: state.isShowAnswer,
              )
                  : Option(
                text: 'Đúng',
                isSelected: state.isAnswerSelected && isSelected[0],
                isCorrectOption: widget.question['answer'] == true,
                isShowAnswer: state.isShowAnswer,
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap:
              !state.isAnswerSelected
                  ? () {
                setState(() {
                  cubit.setIsAnswerSelected(true);
                  isSelected[1] = true;
                  if (widget.question['answer'] == false) {
                    cubit.setTotalCorrectAnswers();
                  }
                  cubit.addAnsweredQuestion({
                    'question': widget.question['word'],
                    'answer':
                    widget.question['answer'] ? 'Đúng' : 'Sai',
                    'userAnswer': 'Sai',
                    'isCorrect': widget.question['answer'] == false,
                    'questionType': 'true_false',
                  });
                });
              }
                  : null,
              child:
              state.isShowAnswer
                  ? Option(
                text: 'Sai',
                isSelected: isSelected[1],
                isCorrectOption: widget.question['answer'] == false,
                isShowAnswer: state.isShowAnswer,
              )
                  : Option(
                text: 'Sai',
                isSelected: state.isAnswerSelected && isSelected[1],
                isCorrectOption: widget.question['answer'] == false,
                isShowAnswer: state.isShowAnswer,
              ),
            ),
          ],
        );
      },
    );
  }
}

//chon dap an dung
class MultipleChoice extends StatefulWidget {
  final Map<String, dynamic> question;

  const MultipleChoice({super.key, required this.question});

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  List<bool> isSelected = List.filled(4, false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        var cubit = context.read<ExamCubit>();
        if (!state.isAnswerSelected) {
          isSelected = List.filled(4, false);
        }
        return Column(
          children: [
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.question['question'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 24),
            ...List.generate(
              widget.question['options'].length,
                  (index) =>
                  Column(
                    children: [
                      InkWell(
                        onTap:
                        !state.isAnswerSelected
                            ? () {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                            cubit.setIsAnswerSelected(true);
                            if (widget.question['options'][index] ==
                                widget.question['answer']) {
                              cubit.setTotalCorrectAnswers();
                            }
                            cubit.addAnsweredQuestion({
                              'question': widget.question['question'],
                              'answer': widget.question['answer'],
                              'userAnswer':
                              widget.question['options'][index],
                              'isCorrect':
                              widget.question['options'][index] ==
                                  widget.question['answer'],
                              'questionType': 'multiple_choice',
                            });
                          });
                        }
                            : null,
                        child:
                        state.isShowAnswer
                            ? Option(
                          text: widget.question['options'][index],
                          isSelected:
                          state.isAnswerSelected
                              ? widget.question['answer'] ==
                              widget.question['options'][index]
                              ? true
                              : isSelected[index]
                              : false,
                          isCorrectOption:
                          widget.question['answer'] ==
                              widget.question['options'][index],
                          isShowAnswer: state.isShowAnswer,
                        )
                            : Option(
                          text: widget.question['options'][index],
                          isSelected: isSelected[index],
                          isCorrectOption: false,
                          isShowAnswer: state.isShowAnswer,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
            ),
          ],
        );
      },
    );
  }
}

//viet cau tra loi
class FillInTheBlank extends StatefulWidget {
  final Map<String, dynamic> question;

  const FillInTheBlank({super.key, required this.question});

  @override
  State<FillInTheBlank> createState() => _FillInTheBlankState();
}

class _FillInTheBlankState extends State<FillInTheBlank> {
  TextEditingController answerController = TextEditingController(text: '');
  int isCorrect = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        var cubit = context.read<ExamCubit>();
        if (!state.isAnswerSelected) {
          answerController.text = '';
          isCorrect = 0;
        }
        return Column(
          children: [
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.question['question'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              enabled: !state.isAnswerSelected,
              controller: answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nhập câu trả lời của bạn',
                disabledBorder: state.isShowAnswer ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                    answerController.text.trim().toLowerCase() ==
                        widget.question['answer'].trim().toLowerCase()
                        ? AppColors.successGreen
                        : AppColors.errorRed,
                    width: 2,
                  ),
                ) : null,
                suffix:
                answerController.text == ''
                    ? GestureDetector(
                  onTap: () {
                    setState(() {
                      cubit.setIsAnswerSelected(true);
                      isCorrect = -1;
                      answerController.text = 'Đã bỏ qua';
                      cubit.addAnsweredQuestion({
                        'question': widget.question['question'],
                        'answer': widget.question['answer'],
                        'userAnswer': '',
                        'isCorrect': false,
                        'questionType': 'fill_in_the_blank',
                      });
                    });
                  },
                  child: Text(
                    'Không biết',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
                    : null,

                prefixIcon:
                state.isAnswerSelected && state.isShowAnswer
                    ? answerController.text.trim().toLowerCase() ==
                    widget.question['answer'].trim().toLowerCase()
                    ? Icon(Icons.check, color: AppColors.successGreen)
                    : Icon(Icons.close, color: AppColors.errorRed)
                    : null,
              ),
              onSubmitted: (value) {
                setState(() {
                  cubit.setIsAnswerSelected(true);
                  if(answerController.text.isEmpty) {
                    answerController.text = 'Đã bỏ qua';
                  }
                  if (value.trim().toLowerCase() ==
                      widget.question['answer'].trim().toLowerCase()) {
                    isCorrect = 1;
                    cubit.setTotalCorrectAnswers();
                  } else {
                    isCorrect = -1;
                  }
                  cubit.addAnsweredQuestion({
                    'question': widget.question['question'],
                    'answer': widget.question['answer'],
                    'userAnswer': value,
                    'isCorrect': isCorrect == 1,
                    'questionType': 'fill_in_the_blank',
                  });
                });
              },
            ),
            SizedBox(height: 24),
            isCorrect == -1 && state.isAnswerSelected && state.isShowAnswer
                ? Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Câu trả lời đúng: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Option(
                  text: widget.question['answer'],
                  isSelected: true,
                  isCorrectOption: true,
                  isShowAnswer: state.isShowAnswer,
                ),
              ],
            )
                : SizedBox(),
          ],
        );
      },
    );
  }
}

//complete screen
class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        var cubit = context.read<ExamCubit>();
        var screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kết quả bài thi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: CircularPercentIndicator(
                      radius: 72,
                      lineWidth: 12,
                      percent:
                      state.totalCorrectAnswers / state.numberOfQuestions,
                      center: Text(
                        '${state.totalCorrectAnswers / state.numberOfQuestions *
                            100}%',
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
                                  'Đúng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  '${state.totalCorrectAnswers}',
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
                                  'Sai',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  '${state.numberOfQuestions -
                                      state.totalCorrectAnswers}',
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
              SizedBox(height: 24),
              primaryButton(false, 'Làm lại bài kiểm tra', 16, () {
                cubit.resetExam();
                Navigator.pop(context);
              }),
              SizedBox(height: 16),
              primaryButton(false, 'Quay lại', 16, () {
                Navigator.pop(context);
              }),
              SizedBox(height: 16),
              Divider(color: AppColors.secondaryGray, thickness: 1),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách câu hỏi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              ...state.answeredQuestions.map(
                    (question) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.lightGray,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question['question'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Đáp án đúng: ${question['answer']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.successGreen,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Câu trả lời của bạn: ${question['userAnswer']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: question['isCorrect']
                                        ? AppColors.successGreen
                                        : AppColors.errorRed,
                                  ),
                                ),
                              ],
                            ),
                            question['isCorrect']
                                ? Icon(
                              Icons.check,
                              color: AppColors.successGreen,
                              size: 40,
                            )
                                : Icon(
                              Icons.close,
                              color: AppColors.errorRed,
                              size: 40,
                            ),
                          ],
                        ),
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

class Option extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrectOption;
  final bool isShowAnswer;

  const Option({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrectOption,
    required this.isShowAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
          isSelected && !isShowAnswer
              ? AppColors.primaryBlue
              : isSelected && isCorrectOption && isShowAnswer
              ? AppColors.successGreen
              : isSelected && !isCorrectOption && isShowAnswer
              ? AppColors.errorRed
              : AppColors.lightGray,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          !isSelected
              ? SizedBox()
              : isCorrectOption && isShowAnswer
              ? Icon(Icons.check, color: AppColors.successGreen)
              : isShowAnswer
              ? Icon(Icons.close, color: AppColors.errorRed)
              : SizedBox(),
          SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }
}
