import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_english_app/core/color.dart';
import 'package:study_english_app/core/text.dart';
import 'package:study_english_app/widgets/button/primary_button.dart';

class LearnScreen extends StatelessWidget {
  static const String route = "LearnScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close_sharp),
        ),
        actionsPadding: EdgeInsets.only(right: 12),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16),
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
                  child: Text('1'),
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
                            width: progressWidth / 10,
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
                  child: Text('10'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '(word type): meaning',
                style: AppTextStyles.bodyMedium,
              ),
            ),
            SizedBox(height: 32),
            Expanded(child: Options()),
          ],
        ),
      ),
    );
  }
}

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  var isOptionsSelected = [false, false, false, false];
  bool isActivated = true;
  Map<String, String> word = {'hello' : 'xin chao'};
  var options = ['hi', 'xin chao', 'bye', 'good'];

  @override
  Widget build(BuildContext context) {
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
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Option(
                          isCorrectOption: options[i].compareTo(word.values.first) == 0,
                          text: options[i],
                          isSelected: isOptionsSelected[i],
                        ),
                      ),
                    )
                    : Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Option(
                        isCorrectOption: options[i].compareTo(word.values.first) == 0,
                        text: options[i],
                        isSelected:  options[i].compareTo(word.values.first) == 0 ? true : isOptionsSelected[i],
                      ),
                    ),
            ],
          ),
        ),
        isActivated ? SizedBox() : SizedBox(
          height: 100,
          child: Center(
            child: primaryButton(false, 'Tiếp tục', null, () {}),
          ),
        ),
      ],
    );
  }
}

class Option extends StatefulWidget {
  const Option({
    super.key,
    required this.isCorrectOption,
    required this.text,
    required this.isSelected,
  });

  final bool isSelected;
  final bool isCorrectOption;
  final String text;

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              widget.isSelected && widget.isCorrectOption
                  ? AppColors.successGreen
                  : widget.isSelected && !widget.isCorrectOption
                  ? AppColors.errorRed
                  : AppColors.lightGray,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          !widget.isSelected ? SizedBox() : SizedBox(width: 16),
          !widget.isSelected
              ? SizedBox()
              : widget.isCorrectOption
              ? Icon(Icons.check, color: AppColors.successGreen)
              : Icon(Icons.close, color: AppColors.errorRed),
          SizedBox(width: 16),
          Text('data'),
        ],
      ),
    );
  }
}
