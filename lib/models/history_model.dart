import 'dart:convert';

class HistoryModel {
  final int? id;
  final String name;
  final double gwa;
  final String semester;
  final bool isDeanLister;
  final Map<String, double>? grades;

  HistoryModel({
    this.id,
    required this.name,
    required this.gwa,
    required this.semester,
    required this.isDeanLister,
    this.grades,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gwa': gwa,
      'semester': semester,
      'isDeanLister': isDeanLister ? 1 : 0,
      'gradesJson': grades != null ? jsonEncode(grades) : null,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    Map<String, double>? decodedGrades;
    final rawGrades = map['gradesJson'];
    if (rawGrades != null) {
      final dynamic parsed = jsonDecode(rawGrades);
      if (parsed is Map<String, dynamic>) {
        decodedGrades = parsed.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );
      }
    }

    return HistoryModel(
      id: map['id'],
      name: map['name'],
      gwa: map['gwa'],
      semester: map['semester'],
      isDeanLister: map['isDeanLister'] == 1,
      grades: decodedGrades,
    );
  }
}
