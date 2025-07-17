import 'package:study_english_app/models/word.dart';

class Courses {
  final String id;
  final String name;
  final int totalWords;
  final String createdBy;
  final DateTime createdAt;
  final List<Word> words;
  final bool isPublic;

  //<editor-fold desc="Data Methods">
  const Courses({
    required this.id,
    required this.name,
    required this.totalWords,
    required this.createdBy,
    required this.createdAt,
    required this.words,
    required this.isPublic,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Courses &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          totalWords == other.totalWords &&
          createdBy == other.createdBy &&
          createdAt == other.createdAt &&
          words == other.words &&
          isPublic == other.isPublic);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      totalWords.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode ^
      words.hashCode ^
      isPublic.hashCode;

  @override
  String toString() {
    return 'Courses{' +
        ' id: $id,' +
        ' name: $name,' +
        ' totalWords: $totalWords,' +
        ' createdBy: $createdBy,' +
        ' createdAt: $createdAt,' +
        ' words: $words,' +
        ' isPublic: $isPublic,' +
        '}';
  }

  Courses copyWith({
    String? id,
    String? name,
    int? totalWords,
    String? createdBy,
    DateTime? createdAt,
    List<Word>? words,
    bool? isPublic,
  }) {
    return Courses(
      id: id ?? this.id,
      name: name ?? this.name,
      totalWords: totalWords ?? this.totalWords,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      words: words ?? this.words,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'totalWords': this.totalWords,
      'createdBy': this.createdBy,
      'createdAt': this.createdAt,
      'words': this.words,
      'isPublic': this.isPublic,
    };
  }

  factory Courses.fromMap(Map<String, dynamic> map) {
    return Courses(
      id: map['id'] as String,
      name: map['name'] as String,
      totalWords: map['totalWords'] as int,
      createdBy: map['createdBy'] as String,
      createdAt: map['createdAt'] as DateTime,
      words: map['words'] as List<Word>,
      isPublic: map['isPublic'] as bool,
    );
  }

  //</editor-fold>
}