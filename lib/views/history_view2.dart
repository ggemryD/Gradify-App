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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Computation History"),
      ),
      body: FutureBuilder<List<HistoryModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          // Show loading indicator while fetching data
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          // Show message if no history is found
          if (snapshot.data!.isEmpty) return const Center(child: Text("No history yet."));

          // Display list of history items
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final history = snapshot.data![index];

              return Card(
                child: ListTile(
                  title: Text("${history.name} - ${history.semester}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("GWA: ${history.gwa.toStringAsFixed(3)}"),
                      Text(
                        history.isDeanLister ? "Dean's Lister" : "Not Dean's Lister",
                        style: TextStyle(
                          color: history.isDeanLister ? Colors.green : Colors.orange,
                          fontWeight: history.isDeanLister ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  trailing: history.isDeanLister
                      ? const Icon(Icons.star, color: Colors.amber)
                      : null,
                  onLongPress: () async {
                    // Delete the selected history
                    await _historyController.deleteHistory(history.id!);
                    _refreshHistory();
                  },
                ),
              );

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete_forever),
        onPressed: () async {
          // Clear all history
          await _historyController.clearHistory();
          _refreshHistory();
        },
      ),
    );
  }
}
