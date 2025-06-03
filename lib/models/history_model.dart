class HistoryModel {
  final int? id;
  final String name;
  final double gwa;
  final String semester;
  final bool isDeanLister;

  HistoryModel({
    this.id,
    required this.name,
    required this.gwa,
    required this.semester,
    required this.isDeanLister,
  });

  // Convert HistoryModel to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gwa': gwa,
      'semester': semester,
      'isDeanLister': isDeanLister ? 1 : 0, // Store as 1 or 0 (SQLite does not have boolean)
    };
  }

  // Convert Map to HistoryModel
  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      name: map['name'],
      gwa: map['gwa'],
      semester: map['semester'],
      isDeanLister: map['isDeanLister'] == 1, // Convert back from 1 or 0
    );
  }
}
