class Categories {
  final int categoryID;
  final String categoryName;

  //<editor-fold desc="Data Methods">
  const Categories({
    required this.categoryID,
    required this.categoryName,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Categories &&
              runtimeType == other.runtimeType &&
              categoryID == other.categoryID &&
              categoryName == other.categoryName
          );


  @override
  int get hashCode =>
      categoryID.hashCode ^
      categoryName.hashCode;


  @override
  String toString() {
    return 'Categories{' +
        ' categoryID: $categoryID,' +
        ' categoryName: $categoryName,' +
        '}';
  }


  Categories copyWith({
    int? categoryID,
    String? categoryName,
  }) {
    return Categories(
      categoryID: categoryID ?? this.categoryID,
      categoryName: categoryName ?? this.categoryName,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'categoryID': this.categoryID,
      'categoryName': this.categoryName,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      categoryID: map['categoryID'] as int,
      categoryName: map['categoryName'] as String,
    );
  }


//</editor-fold>
}