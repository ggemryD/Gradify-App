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
  final GwaController _gwaController = GwaController(); // For color utility

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

  // Get color based on GWA (same as in home page)
  Color _getGwaColor(double gwa) {
    if (gwa <= 1.5) return Colors.green.shade600; // Excellent
    if (gwa <= 2.0) return Colors.blue.shade600;  // Very Good
    if (gwa <= 2.5) return Colors.amber.shade600; // Good
    if (gwa <= 3.0) return Colors.orange.shade600; // Satisfactory
    return Colors.red.shade600; // Needs Improvement
  }

  // Show confirmation dialog before deleting
  Future<void> _showDeleteConfirmation(BuildContext context, int id, String name) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red.shade700),
            const SizedBox(width: 10),
            const Flexible(
              child: Text("Delete Record", 
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text("Are you sure you want to delete $name's record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _historyController.deleteHistory(id);
              _refreshHistory();
            },
            child: Text("Delete", style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog before clearing all history
  Future<void> _showClearConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red.shade700),
            const SizedBox(width: 10),
            const Flexible(
              child: Text("Clear All History", 
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text("Are you sure you want to clear all history records? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _historyController.clearHistory();
              _refreshHistory();
            },
            child: Text("Clear All", style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            const Flexible(
              child: Text("History", 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(Icons.assessment, size: 24, color: Colors.indigo.shade700),
                        const SizedBox(width: 8),
                        Text(
                          "Past Calculations",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Long-press any record to delete it",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Divider(height: 24),
                    
                    // History List
                    Expanded(
                      child: FutureBuilder<List<HistoryModel>>(
                        future: _historyFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(color: Colors.indigo.shade700),
                            );
                          }
                          
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No calculation history yet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Your past calculations will appear here",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final history = snapshot.data![index];
                              
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onLongPress: () => _showDeleteConfirmation(context, history.id!, history.name),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Left side - GWA circle
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _getGwaColor(history.gwa).withOpacity(0.2),
                                            border: Border.all(
                                              color: _getGwaColor(history.gwa),
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              history.gwa.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: _getGwaColor(history.gwa),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        
                                        // Right side - Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      history.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (history.isDeanLister)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.shade100,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.emoji_events, color: Colors.green.shade700, size: 14),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            "Dean's List",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.green.shade700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                history.semester,
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              if (!history.isDeanLister)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.shade50,
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: Colors.orange.shade200),
                                                  ),
                                                  child: Text(
                                                    "Not a Dean's Lister",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.orange.shade800,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red.shade600,
        onPressed: () => _showClearConfirmation(context),
        icon: const Icon(Icons.delete_sweep, color: Colors.white),
        label: const Text("Clear All", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}