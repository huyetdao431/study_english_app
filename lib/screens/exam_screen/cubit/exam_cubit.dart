import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_english_app/common/enum/load_status.dart';

import '../../../models/word.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit() : super(ExamState.init());

  void setWords(List<Word> words) {
    emit(state.copyWith(words: words));
  }

  void generateQuestions(
    List<Word> words,
  ) {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    final Random random = Random();
    final copiedWords = List<Word>.from(words)..shuffle(random);
    List<Word> trueOrFalseQuestions = [];
    List<Word> multipleChoiceQuestions = [];
    List<Word> fillInTheBlankQuestions = [];

    if (state.isTrueOrFalse && state.isMultipleChoice && state.isFillInTheBlank) {
      int numberOfTrueFalse = (state.numberOfQuestions * 0.45).floor();
      int numberOfMultipleChoice = (state.numberOfQuestions * 0.4).floor();

      for (int i = 0; i < copiedWords.length; i++) {
        if (i < numberOfTrueFalse) {
          trueOrFalseQuestions.add(copiedWords[i]);
        } else if (i < numberOfTrueFalse + numberOfMultipleChoice) {
          multipleChoiceQuestions.add(copiedWords[i]);
        } else {
          fillInTheBlankQuestions.add(copiedWords[i]);
        }
      }
      emit(
        state.copyWith(
          questions: [
            ...generateTrueFalseQuestions(trueOrFalseQuestions),
            ...generateMultipleChoiceQuestions(multipleChoiceQuestions),
            ...generateFillInTheBlankQuestions(fillInTheBlankQuestions),
          ],
          loadStatus: LoadStatus.Success,
        ),
      );
    } else if (state.isTrueOrFalse && state.isMultipleChoice) {
      for (int i = 0; i < copiedWords.length; i++) {
        if (i < (state.numberOfQuestions * 0.55).floor()) {
          trueOrFalseQuestions.add(copiedWords[i]);
        } else {
          multipleChoiceQuestions.add(copiedWords[i]);
        }
      }
      emit(
        state.copyWith(
          questions: [
            ...generateTrueFalseQuestions(trueOrFalseQuestions),
            ...generateMultipleChoiceQuestions(multipleChoiceQuestions),
          ],
          loadStatus: LoadStatus.Success,
        ),
      );
    } else if (state.isMultipleChoice && state.isFillInTheBlank) {
      for (int i = 0; i < copiedWords.length; i++) {
        if (i < (state.numberOfQuestions * 0.7).floor()) {
          multipleChoiceQuestions.add(copiedWords[i]);
        } else {
          fillInTheBlankQuestions.add(copiedWords[i]);
        }
      }
      emit(
        state.copyWith(
          questions: [
            ...generateMultipleChoiceQuestions(multipleChoiceQuestions),
            ...generateFillInTheBlankQuestions(fillInTheBlankQuestions),
          ],
          loadStatus: LoadStatus.Success,
        ),
      );
    } else if (state.isFillInTheBlank && state.isTrueOrFalse) {
      for (int i = 0; i < copiedWords.length; i++) {
        if (i < (state.numberOfQuestions * 0.7).floor()) {
          trueOrFalseQuestions.add(copiedWords[i]);
        } else {
          fillInTheBlankQuestions.add(copiedWords[i]);
        }
      }
      emit(
        state.copyWith(
          questions: [
            ...generateTrueFalseQuestions(trueOrFalseQuestions),
            ...generateFillInTheBlankQuestions(fillInTheBlankQuestions),
          ],
          loadStatus: LoadStatus.Success,
        ),
      );
    } else if (state.isFillInTheBlank) {
      emit(
        state.copyWith(
          questions: generateFillInTheBlankQuestions(copiedWords),
          loadStatus: LoadStatus.Success,
        ),
      );
    } else if (state.isTrueOrFalse) {
      emit(
        state.copyWith(
          questions: generateTrueFalseQuestions(copiedWords),
          loadStatus: LoadStatus.Success,
        ),
      );
    } else if (state.isMultipleChoice) {
      emit(
        state.copyWith(
          questions: generateMultipleChoiceQuestions(copiedWords),
          loadStatus: LoadStatus.Success,
        ),
      );
    }
  }

  List<Map<String, dynamic>> generateTrueFalseQuestions(List<Word> words) {
    final random = Random();
    final shuffledWords = List<Word>.from(words)..shuffle();

    int half = (shuffledWords.length / 2).floor();
    List<Map<String, dynamic>> questions = [];

    for (int i = 0; i < half; i++) {
      final word = shuffledWords[i];
      questions.add({
        'word': word.word,
        'meaning': word.meaning,
        'questionType': 'true_false',
        'answer': true,
      });
    }

    for (int i = half; i < shuffledWords.length; i++) {
      final word = shuffledWords[i];
      String wrongMeaning;
      do {
        wrongMeaning = words[random.nextInt(words.length)].meaning;
      } while (wrongMeaning == word.meaning);

      questions.add({
        'word': word.word,
        'meaning': wrongMeaning,
        'questionType': 'true_false',
        'answer': false,
      });
    }

    questions.shuffle();

    return questions;
  }

  List<Map<String, dynamic>> generateMultipleChoiceQuestions(List<Word> words) {
    final random = Random();
    final wordList = List<Word>.from(words)..shuffle();

    List<Map<String, dynamic>> questions = [];

    for (var word in wordList) {
      bool askForMeaning = random.nextBool();

      String question;
      String answer;
      List<String> options = [];

      if (askForMeaning) {
        question = word.word;
        answer = word.meaning;
        options = [answer];

        final wrongMeanings =
            words
                .where((w) => w.meaning != answer)
                .map((w) => w.meaning)
                .toList()
              ..shuffle();

        options.addAll(wrongMeanings.take(3));
      } else {
        question = word.meaning;
        answer = word.word;
        options = [answer];

        final wrongWords =
            words.where((w) => w.word != answer).map((w) => w.word).toList()
              ..shuffle();

        options.addAll(wrongWords.take(3));
      }

      options.shuffle();

      questions.add({
        'question': question,
        'answer': answer,
        'options': options,
        'questionType': 'multiple_choice',
      });
    }

    return questions;
  }

  List<Map<String, dynamic>> generateFillInTheBlankQuestions(List<Word> words) {
    words.shuffle();
    final questions = <Map<String, dynamic>>[];
    final random = Random();

    for (var word in words) {
      final isWordQuestion = random.nextBool();

      questions.add({
        'question': isWordQuestion ? word.meaning : word.word,
        'answer': isWordQuestion ? word.word : word.meaning,
        'questionType': 'fill_in_the_blank',
      });
    }

    return questions;
  }

  void setIsAnswerSelected(bool value) {
    emit(state.copyWith(isAnswerSelected: value));
  }
  void setIsTrueOrFalse(bool value) {
    emit(state.copyWith(isTrueOrFalse: value));
  }
  void setIsMultipleChoice(bool value) {
    emit(state.copyWith(isMultipleChoice: value));
  }
  void setIsFillInTheBlank(bool value) {
    emit(state.copyWith(isFillInTheBlank: value));
  }
  void setIsExamStarted(bool value) {
    emit(state.copyWith(isExamStarted: value));
  }
  void setIsShowAnswer(bool value) {
    emit(state.copyWith(isShowAnswer: value));
  }
  void setNumberOfQuestions(int number) {
    emit(state.copyWith(numberOfQuestions: number));
  }
  void resetIsShowAnswer() {
    emit(state.copyWith(isShowAnswer: false));
  }
  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    }
  }

  Map<String, dynamic> getCurrentQuestion() {
    if (state.currentQuestionIndex < state.questions.length) {
      return state.questions[state.currentQuestionIndex];
    }
    return {};
  }
  void setTotalCorrectAnswers() {
    emit(state.copyWith(totalCorrectAnswers: state.totalCorrectAnswers + 1));
  }
  void addAnsweredQuestion(Map<String, dynamic> question) {
    final answeredQuestions = [...state.answeredQuestions, question];
    emit(state.copyWith(answeredQuestions: answeredQuestions));
  }
  void resetExam() {
    emit(ExamState.init());
  }
}
