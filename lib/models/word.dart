class Word {
  final String word;
  final String meaning;
  final String phonetic;
  final String courseId;
  final int categoryId;
  final String wordType;

  //<editor-fold desc="Data Methods">
  const Word({
    required this.word,
    required this.meaning,
    required this.phonetic,
    required this.courseId,
    required this.categoryId,
    required this.wordType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          runtimeType == other.runtimeType &&
          word == other.word &&
          meaning == other.meaning &&
          phonetic == other.phonetic &&
          courseId == other.courseId &&
          categoryId == other.categoryId &&
          wordType == other.wordType);

  @override
  int get hashCode =>
      word.hashCode ^
      meaning.hashCode ^
      phonetic.hashCode ^
      courseId.hashCode ^
      categoryId.hashCode ^
      wordType.hashCode;

  @override
  String toString() {
    return 'Word{' +
        ' word: $word,' +
        ' meaning: $meaning,' +
        ' phonetic: $phonetic,' +
        ' courseId: $courseId,' +
        ' categoryId: $categoryId,' +
        ' wordType: $wordType,' +
        '}';
  }

  Word copyWith({
    String? word,
    String? meaning,
    String? phonetic,
    String? courseId,
    int? categoryId,
    String? wordType,
  }) {
    return Word(
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      phonetic: phonetic ?? this.phonetic,
      courseId: courseId ?? this.courseId,
      categoryId: categoryId ?? this.categoryId,
      wordType: wordType ?? this.wordType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': this.word,
      'meaning': this.meaning,
      'phonetic': this.phonetic,
      'courseId': this.courseId,
      'categoryId': this.categoryId,
      'wordType': this.wordType,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] ?? '',
      meaning: map['meaning'] ?? '',
      phonetic: map['phonetic'] ?? '',
      courseId: map['courseId'] ?? '',
      categoryId: map['categoryId'] ?? 0,
      wordType: map['wordType'] ?? '',
    );
  }


  //</editor-fold>
}