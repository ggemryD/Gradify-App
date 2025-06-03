import '../models/history_model.dart';
import '../database/database_helper.dart';

class HistoryController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> saveHistory(String name, double gwa, String semester, {Map<String, double>? grades}) async {
    // Check both GWA criteria and individual grades criteria
    bool isDeanLister = false;
    
    if (gwa <= 1.75) {
      // If grades are provided, check if any are >= 2.6
      if (grades != null) {
        // If no grades are >= 2.6, then isDeanLister should be true
        isDeanLister = !grades.values.any((grade) => grade >= 2.6);
      } else {
        // If no grades are provided, just use GWA (fallback to old behavior)
        isDeanLister = true;
      }
    }

    HistoryModel history = HistoryModel(
      name: name,
      gwa: gwa,
      semester: semester,
      isDeanLister: isDeanLister,
    );

    await _dbHelper.insertHistory(history); // Save to DB
  }

  Future<List<HistoryModel>> fetchHistory() async {
    return await _dbHelper.getHistory(); // Get saved data
  }

  Future<void> deleteHistory(int id) async {
    await _dbHelper.deleteHistory(id);
  }

  Future<void> clearHistory() async {
    await _dbHelper.clearHistory();
  }
}