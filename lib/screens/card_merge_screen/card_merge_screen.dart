import 'package:flutter/material.dart';
import 'package:study_english_app/core/color.dart';
import '../../models/word.dart';

class CardMergeScreen extends StatefulWidget {
  final List<Word> words;
  const CardMergeScreen({super.key, required this.words});

  static const String route = 'CardMergeScreen';

  @override
  State<CardMergeScreen> createState() => _CardMergeScreenState();
}

class _CardMergeScreenState extends State<CardMergeScreen> {
  List<MapEntry<String, String>> selectedPairs = [];
  List<String> cardContent = [];
  List<bool> isVisible = List.filled(12, true);
  List<int> selectedIndices = [];
  List<Color?> cardColors = List.filled(12, null);
  bool _isCompleted = false;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _setupCards();
  }

  void _setupCards() {
    final wordList = widget.words.toList();
    wordList.shuffle();
    selectedPairs = wordList.take(6).map((e) => MapEntry(e.word, e.meaning)).toList();

    cardContent = [];
    for (var pair in selectedPairs) {
      cardContent.add(pair.key);
      cardContent.add(pair.value);
    }
    cardContent.shuffle();
  }

  void onCardTap(int index) {
    if (!isVisible[index] || selectedIndices.contains(index)) return;

    setState(() {
      selectedIndices.add(index);
      cardColors[index] = AppColors.primaryLight; // Chọn
    });

    if (selectedIndices.length == 2) {
      _isChecking = true;
      final first = cardContent[selectedIndices[0]];
      final second = cardContent[selectedIndices[1]];

      final isPair = selectedPairs.any((pair) =>
      (pair.key == first && pair.value == second) ||
          (pair.key == second && pair.value == first));

      if (isPair) {
        setState(() {
          cardColors[selectedIndices[0]] = AppColors.successGreen.withAlpha(150);
          cardColors[selectedIndices[1]] = AppColors.successGreen.withAlpha(150);
        });

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            isVisible[selectedIndices[0]] = false;
            isVisible[selectedIndices[1]] = false;
            selectedIndices.clear();

            if (isVisible.every((e) => !e)) {
              _isCompleted = true;
            }
            _isChecking = false;
          });
        });
      } else {
        setState(() {
          cardColors[selectedIndices[0]] = AppColors.errorRed;
          cardColors[selectedIndices[1]] = AppColors.errorRed;
        });

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            cardColors[selectedIndices[0]] = null;
            cardColors[selectedIndices[1]] = null;
            selectedIndices.clear();
            _isChecking = false;
          });
        });
      }
    }
  }

  Widget _completeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chúc mừng bạn đã hoàn thành!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _restartGame,
            child: Text('Chơi lại'),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      selectedPairs.clear();
      cardContent.clear();
      isVisible = List.filled(12, true);
      cardColors = List.filled(12, null);
      selectedIndices.clear();
      _isCompleted = false;
      _setupCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ghép thẻ"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:!_isCompleted ? LayoutBuilder(
          builder: (context, constraints) {
            double itemHeight = constraints.maxHeight / 4.5;
            double itemWidth = constraints.maxWidth / 3.5;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (j) {
                    int index = i * 3 + j;
                    return _buildCard(index, itemHeight, itemWidth);
                  }),
                );
              }),
            );
          },
        ) : _completeScreen(),
      ),
    );
  }

  Widget _buildCard(int index, double height, double width) {
    if (!isVisible[index]) return SizedBox(height: height, width: width);

    return GestureDetector(
      onTap: () => !_isChecking ? onCardTap(index) : null,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cardColors[index] ?? AppColors.primaryLight.withAlpha(36),
          border: Border.all(color: cardColors[index] ?? AppColors.primaryDark),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          cardContent[index],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: selectedIndices.contains(index) ? Colors.white : AppColors.primaryDark),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
