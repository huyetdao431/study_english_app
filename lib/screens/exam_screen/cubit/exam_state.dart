part of 'exam_cubit.dart';

class ExamState {
  final LoadStatus loadStatus;
  final List<Word> words;
  final int numberOfQuestions;
  final int currentQuestionIndex;
  final bool isAnswerSelected;
  final bool isShowAnswer;
  final bool isTrueOrFalse;
  final bool isMultipleChoice;
  final bool isFillInTheBlank;
  final bool isExamStarted;
  final List<Map<String, dynamic>> questions;
  final int totalCorrectAnswers;
  final List<Map<String, dynamic>> answeredQuestions;

  const ExamState.init({
    this.loadStatus = LoadStatus.Init,
    this.words = const [],
    this.numberOfQuestions = 0,
    this.currentQuestionIndex = 0,
    this.isAnswerSelected = false,
    this.isShowAnswer = false,
    this.isTrueOrFalse = false,
    this.isMultipleChoice = true,
    this.isFillInTheBlank = false,
    this.isExamStarted = false,
    this.questions = const [],
    this.totalCorrectAnswers = 0,
    this.answeredQuestions = const [],
  });

  //<editor-fold desc="Data Methods">
  const ExamState({
    required this.loadStatus,
    required this.words,
    required this.numberOfQuestions,
    required this.currentQuestionIndex,
    required this.isAnswerSelected,
    required this.isShowAnswer,
    required this.isTrueOrFalse,
    required this.isMultipleChoice,
    required this.isFillInTheBlank,
    required this.isExamStarted,
    required this.questions,
    required this.totalCorrectAnswers,
    required this.answeredQuestions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamState &&
          runtimeType == other.runtimeType &&
          loadStatus == other.loadStatus &&
          words == other.words &&
          numberOfQuestions == other.numberOfQuestions &&
          currentQuestionIndex == other.currentQuestionIndex &&
          isAnswerSelected == other.isAnswerSelected &&
          isShowAnswer == other.isShowAnswer &&
          isTrueOrFalse == other.isTrueOrFalse &&
          isMultipleChoice == other.isMultipleChoice &&
          isFillInTheBlank == other.isFillInTheBlank &&
          isExamStarted == other.isExamStarted &&
          questions == other.questions &&
          totalCorrectAnswers == other.totalCorrectAnswers &&
          answeredQuestions == other.answeredQuestions);

  @override
  int get hashCode =>
      loadStatus.hashCode ^
      words.hashCode ^
      numberOfQuestions.hashCode ^
      currentQuestionIndex.hashCode ^
      isAnswerSelected.hashCode ^
      isShowAnswer.hashCode ^
      isTrueOrFalse.hashCode ^
      isMultipleChoice.hashCode ^
      isFillInTheBlank.hashCode ^
      isExamStarted.hashCode ^
      questions.hashCode ^
      totalCorrectAnswers.hashCode ^
      answeredQuestions.hashCode;

  @override
  String toString() {
    return 'ExamState{' +
        ' loadStatus: $loadStatus,' +
        ' words: $words,' +
        ' numberOfQuestions: $numberOfQuestions,' +
        ' currentQuestionIndex: $currentQuestionIndex,' +
        ' isAnswerSelected: $isAnswerSelected,' +
        ' isShowAnswer: $isShowAnswer,' +
        ' isTrueOrFalse: $isTrueOrFalse,' +
        ' isMultipleChoice: $isMultipleChoice,' +
        ' isFillInTheBlank: $isFillInTheBlank,' +
        ' isExamStarted: $isExamStarted,' +
        ' questions: $questions,' +
        ' totalCorrectAnswers: $totalCorrectAnswers,' +
        ' answeredQuestions: $answeredQuestions,' +
        '}';
  }

  ExamState copyWith({
    LoadStatus? loadStatus,
    List<Word>? words,
    int? numberOfQuestions,
    int? currentQuestionIndex,
    bool? isAnswerSelected,
    bool? isShowAnswer,
    bool? isTrueOrFalse,
    bool? isMultipleChoice,
    bool? isFillInTheBlank,
    bool? isExamStarted,
    List<Map<String, dynamic>>? questions,
    int? totalCorrectAnswers,
    List<Map<String, dynamic>>? answeredQuestions,
  }) {
    return ExamState(
      loadStatus: loadStatus ?? this.loadStatus,
      words: words ?? this.words,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isAnswerSelected: isAnswerSelected ?? this.isAnswerSelected,
      isShowAnswer: isShowAnswer ?? this.isShowAnswer,
      isTrueOrFalse: isTrueOrFalse ?? this.isTrueOrFalse,
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
      isFillInTheBlank: isFillInTheBlank ?? this.isFillInTheBlank,
      isExamStarted: isExamStarted ?? this.isExamStarted,
      questions: questions ?? this.questions,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loadStatus': this.loadStatus,
      'words': this.words,
      'numberOfQuestions': this.numberOfQuestions,
      'currentQuestionIndex': this.currentQuestionIndex,
      'isAnswerSelected': this.isAnswerSelected,
      'isShowAnswer': this.isShowAnswer,
      'isTrueOrFalse': this.isTrueOrFalse,
      'isMultipleChoice': this.isMultipleChoice,
      'isFillInTheBlank': this.isFillInTheBlank,
      'isExamStarted': this.isExamStarted,
      'questions': this.questions,
      'totalCorrectAnswers': this.totalCorrectAnswers,
      'answeredQuestions': this.answeredQuestions,
    };
  }

  factory ExamState.fromMap(Map<String, dynamic> map) {
    return ExamState(
      loadStatus: map['loadStatus'] as LoadStatus,
      words: map['words'] as List<Word>,
      numberOfQuestions: map['numberOfQuestions'] as int,
      currentQuestionIndex: map['currentQuestionIndex'] as int,
      isAnswerSelected: map['isAnswerSelected'] as bool,
      isShowAnswer: map['isShowAnswer'] as bool,
      isTrueOrFalse: map['isTrueOrFalse'] as bool,
      isMultipleChoice: map['isMultipleChoice'] as bool,
      isFillInTheBlank: map['isFillInTheBlank'] as bool,
      isExamStarted: map['isExamStarted'] as bool,
      questions: map['questions'] as List<Map<String, dynamic>>,
      totalCorrectAnswers: map['totalCorrectAnswers'] as int,
      answeredQuestions: map['answeredQuestions'] as List<Map<String, dynamic>>,
    );
  }

  //</editor-fold>
}
