import 'package:flutter/material.dart';
import '../controllers/gwa_controller.dart';
import '../models/subject.dart';
import '../views/history_view.dart';
import '../controllers/history_controller.dart';
import '../models/history_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final HistoryController _historyController = HistoryController();
  final HistoryController historyController = HistoryController();

  final GwaController gwaController = GwaController();
  final TextEditingController nameController = TextEditingController();
  String? selectedYear;
  String? selectedSem;
  List<Subject> selectedSubjects = [];
  Map<String, TextEditingController> gradeControllers = {};
  double? gwa;
  bool isDeanLister = false;

  void updateSubjects() {
    if (selectedYear != null && selectedSem != null) {
      selectedSubjects = gwaController.getSubjects(selectedYear!, selectedSem!);
      gradeControllers.clear();
      for (var subject in selectedSubjects) {
        gradeControllers[subject.name] = TextEditingController();
      }
      setState(() {});
    }
  }

  void calculateGWA() {
    Map<String, double> grades = {};
    for (var subject in selectedSubjects) {
      double? grade = double.tryParse(gradeControllers[subject.name]?.text ?? '');
      if (grade != null && grade >= 1.0 && grade <= 5.0) {
        grades[subject.name] = grade;
      }
    }

    setState(() {
      gwa = gwaController.calculateGWA(grades, selectedSubjects);
      isDeanLister = gwa! <= 1.75 && !grades.values.any((grade) => grade >= 2.6);
      
      // SAVE TO DATABASE
      String studentName = nameController.text.isNotEmpty ? nameController.text : "Anonymous";
      String semesterInfo = "$selectedYear Year, $selectedSem Semester";
      // historyController.saveHistory(studentName, gwa!, semesterInfo);
      historyController.saveHistory(studentName, gwa!, semesterInfo, grades: grades);
    });
    
    // Show results in popup
    showResultsDialog();
  }

  void showResultsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisSize: MainAxisSize.min, // Prevent title overflow
          children: [
            Icon(Icons.assessment, color: Colors.indigo.shade700),
            const SizedBox(width: 10),
            const Flexible(
              child: Text("GWA Results", 
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your GWA:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${gwa!.toStringAsFixed(3)}",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getGwaColor(gwa!),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDeanLister ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDeanLister ? Colors.green.shade200 : Colors.orange.shade200,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDeanLister ? Icons.emoji_events : Icons.star,
                        color: isDeanLister ? Colors.green.shade700 : Colors.orange.shade700,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isDeanLister
                            ? "Dean's Lister!"
                            : "Not a Dean's Lister",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDeanLister ? Colors.green.shade800 : Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isDeanLister 
                            ? "Congratulations! You qualified for the Dean's List. Your hard work and dedication have truly paid off!"
                            : "Keep going! While you didn't qualify for the Dean's List this time, your efforts are valuable. Every step forward is progress!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDeanLister ? Colors.green.shade800 : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void resetFields() {
    nameController.clear();
    selectedYear = null;
    selectedSem = null;
    selectedSubjects.clear();
    gradeControllers.clear();
    gwa = null;
    isDeanLister = false;
    setState(() {});
  }

  void showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisSize: MainAxisSize.min, // Prevent title overflow
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700),
            const SizedBox(width: 10),
            const Flexible(
              child: Text("Help & Information", 
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHelpSection(
                  "How GWA is Calculated",
                  "GWA = (Sum of (Grade × Units)) / (Total Units)",
                  Icons.calculate,
                ),
                const Divider(),
                _buildHelpSection(
                  "Dean's Lister Qualification",
                  "• GWA of 1.750 or better\n• No grade lower than 2.6 in any subject",
                  Icons.school,
                ),
                const Divider(),
                _buildHelpSection(
                  "Important Note",
                  "To clear all input fields and start over, click the refresh icon in the top-right corner of the screen.",
                  Icons.note_alt, // or Icons.warning
                ),
                const Divider(),
                _buildHelpSection(
                  "About GradifY",
                  "Developed by GGemry :D 💻🐟",
                  Icons.code_off,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Got It!", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
  
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
          mainAxisSize: MainAxisSize.min, // Prevent overflow in title
          children: [
            Icon(Icons.school, color: Colors.white),
            const SizedBox(width: 10),
            const Flexible(
              child: Text("GradifY", 
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Reset Fields",
            onPressed: resetFields,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            tooltip: "Help",
            onPressed: showHelpDialog,
          ),
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryView()),
              );
            },
          ),
        ],
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
          child: Column(
            children: [
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              // App Logo/Header
                              Icon(Icons.grade, size: 48, color: Colors.indigo.shade700),
                              const SizedBox(height: 10),
                              const Text(
                                "Grade Calculator",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                "Calculate your GWA and check Dean's List eligibility",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const Divider(height: 30),
                              
                              // Student Info Section
                              _buildSectionTitle("Student Information", Icons.person),
                              const SizedBox(height: 10),
                              
                              // Name Input
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.indigo.shade700, width: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              
                              // Year and Semester Row
                              Row(
                                children: [
                                  // Year Level Dropdown
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: selectedYear,
                                      isExpanded: true, // Prevent overflow in dropdown
                                      decoration: InputDecoration(
                                        labelText: "Year Level",
                                        prefixIcon: const Icon(Icons.calendar_today),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade400),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.indigo.shade700, width: 2),
                                        ),
                                      ),
                                      hint: const Text("Year"),
                                      items: ['1st', '2nd', '3rd', '4th'].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedYear = value;
                                          updateSubjects();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  
                                  // Semester Dropdown
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: selectedSem,
                                      isExpanded: true, // Prevent overflow in dropdown
                                      decoration: InputDecoration(
                                        labelText: "Semester",
                                        prefixIcon: const Icon(Icons.event_note),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade400),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.indigo.shade700, width: 2),
                                        ),
                                      ),
                                      hint: const Text("Sem"),
                                      items: ['1st', '2nd'].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSem = value;
                                          updateSubjects();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Subject Grades Section - Using SliverList for better scrolling performance
                        if (selectedSubjects.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                _buildSectionTitle("Subject Grades", Icons.assignment),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          
                          // Subject List - Using SliverList for better performance
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final subject = selectedSubjects[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.indigo.shade100,
                                          child: Text(
                                            "${subject.units}",
                                            style: TextStyle(
                                              color: Colors.indigo.shade800,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                subject.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis, // Handle long subject names
                                                maxLines: 2,
                                              ),
                                              Text(
                                                "${subject.units} Units",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                            controller: gradeControllers[subject.name],
                                            decoration: InputDecoration(
                                              hintText: "1.0-5.0",
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: selectedSubjects.length,
                            ),
                          ),
                          
                          // Calculate Button
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                              child: ElevatedButton.icon(
                                onPressed: calculateGWA,
                                icon: Icon(Icons.calculate, color: Colors.white), // Change icon color
                                label: Text(
                                  "Calculate GWA",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Change text color
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo.shade700, // Button background color
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.indigo.shade700),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}