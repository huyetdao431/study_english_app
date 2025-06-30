import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';

class CardMergeScreen extends StatefulWidget {
  const CardMergeScreen({super.key});

  static const String route = 'CardMergeScreen';

  @override
  State<CardMergeScreen> createState() => _CardMergeScreenState();
}

class _CardMergeScreenState extends State<CardMergeScreen> {
  final words = [
    {'hello': 'xin chào'},
    {'goodbye': 'tạm biệt'},
    {'thank you': 'cảm ơn'},
    {'sorry': 'xin lỗi'},
    {'yes': 'vâng'},
    {'no': 'không'},
  ];
  List<bool> isAvailable = List.filled(12, false);
  var cardContent = [];
  void getCardContent() {
    for(var item in words) {
      cardContent.add(item.keys.first);
      cardContent.add(item.values.first);
    }
    cardContent.shuffle();
  }
  @override
  Widget build(BuildContext context) {
    getCardContent();
    print(cardContent);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text('Ghép thẻ'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double columnHei = constraints.maxHeight;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 4; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int j = i * 3; j < i*3+3; j++)
                      SizedBox(height: columnHei/4, width: columnHei/4/1.2, child: _card(cardContent[j])),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _card(String text) {
    bool isSelected = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.purple.withAlpha(100)
                      : AppColors.darkWhite,
              border: Border.all(
                color: isSelected ? Colors.purple : AppColors.secondaryGray,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(text),
          ),
        );
      },
    );
  }
}
