import 'package:flutter/material.dart';
import '../controllers/history_controller.dart';
import '../models/history_model.dart';
import '../controllers/gwa_controller.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryController _historyController = HistoryController();
  late Future<List<HistoryModel>> _historyFuture;
  
  @override
  void initState() {
    super.initState();
    _historyFuture = _historyController.fetchHistory();
  }
  
  void _refreshHistory() {
    setState(() {
      _historyFuture = _historyController.fetchHistory();
    });
  }
  
  // Show confirmation dialog before deleting item
  Future<void> _confirmDelete(int id, String name) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red.shade700),
              const SizedBox(width: 10),
              const Text('Confirm Deletion'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the record for "$name"?'),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red.shade700)),
              onPressed: () async {
                await _historyController.deleteHistory(id);
                Navigator.of(context).pop();
                _refreshHistory();
                
                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Record deleted successfully'),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'DISMISS',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog before clearing all history
  Future<void> _confirmClearAll() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
              const SizedBox(width: 10),
              const Text('Clear All History'),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to clear all computation history?'),
                SizedBox(height: 8),
                Text(
                  'This will permanently delete all records and cannot be undone.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Clear All', style: TextStyle(color: Colors.red.shade700)),
              onPressed: () async {
                await _historyController.clearHistory();
                Navigator.of(context).pop();
                _refreshHistory();
                
                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All records cleared successfully'),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'DISMISS',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Get color based on GWA value
  Color _getGwaColor(double gwa) {
    if (gwa <= 1.5) return Colors.green.shade600; // Excellent
    if (gwa <= 2.0) return Colors.blue.shade600;  // Very Good
    if (gwa <= 2.5) return Colors.amber.shade600; // Good
    if (gwa <= 3.0) return Colors.orange.shade600; // Satisfactory
    return Colors.red.shade600; // Needs Improvement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            // Icon(Icons.history, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Computation History",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo.shade700,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: Colors.white),
        //     tooltip: "Refresh",
        //     onPressed: _refreshHistory,
        //   ),
        // ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<HistoryModel>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.indigo.shade700),
                    const SizedBox(height: 20),
                    Text(
                      "Loading history...",
                      style: TextStyle(
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red.shade700),
                    const SizedBox(height: 20),
                    const Text(
                      "Error loading history",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _refreshHistory,
                      child: Text(
                        "Try Again",
                        style: TextStyle(color: Colors.indigo.shade700),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 20),
                    Text(
                      "No History Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Calculate your GWA to see history here",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calculate),
                      label: const Text("Go to Calculator"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
            
            // Display list of history items
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final history = snapshot.data![index];
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Dismissible(
                      key: Key(history.id.toString()),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete_sweep,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        await _confirmDelete(history.id!, history.name);
                        return false; // Return false to prevent the dismissible from removing the item
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: _getGwaColor(history.gwa),
                          child: Text(
                            history.gwa.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        title: Text(
                          history.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              history.semester,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: history.isDeanLister ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: history.isDeanLister ? Colors.green.shade700 : Colors.orange.shade700,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                history.isDeanLister ? "Dean's Lister" : "Not Dean's Lister",
                                style: TextStyle(
                                  color: history.isDeanLister ? Colors.green.shade800 : Colors.orange.shade800,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: history.isDeanLister
                            ? Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 28)
                            : Icon(Icons.star_border, color: Colors.grey.shade400, size: 28),
                        onTap: () {
                          // Show detailed view if needed in the future
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.delete_forever),
        label: const Text("Clear All"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        onPressed: _confirmClearAll,
      ),
    );
  }
}