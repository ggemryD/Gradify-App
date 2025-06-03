import 'package:flutter/material.dart';
import '../controllers/gwa_controller.dart';
import '../models/subject.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GwaController gwaController = GwaController();
  final TextEditingController nameController = TextEditingController();
  String? selectedYear;
  String? selectedSem;
  List<Subject> selectedSubjects = [];
  Map<String, TextEditingController> gradeControllers = {};
  double? gwa;
  String deanStatus = '';

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

    // setState(() {
    //   gwa = gwaController.calculateGWA(grades, selectedSubjects);
    //   deanStatus = gwaController.getDeanStatus(gwa!);
    // });

    setState(() {
      gwa = gwaController.calculateGWA(grades, selectedSubjects);
      deanStatus = gwaController.getDeanStatus(gwa!, grades);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GWA Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Input Fields
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Year Level Dropdown
            DropdownButtonFormField<String>(
              value: selectedYear,
              decoration: InputDecoration(border: OutlineInputBorder()),
              hint: Text("Select Year Level"),
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
            SizedBox(height: 10),

            // Semester Dropdown
            DropdownButtonFormField<String>(
              value: selectedSem,
              decoration: InputDecoration(border: OutlineInputBorder()),
              hint: Text("Select Semester"),
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
            SizedBox(height: 10),

            // Subject List & GWA Calculation
            if (selectedSubjects.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Enter Grades:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectedSubjects.length,
                        itemBuilder: (context, index) {
                          final subject = selectedSubjects[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextField(
                              controller: gradeControllers[subject.name],
                              decoration: InputDecoration(
                                labelText: "${subject.name} (${subject.units} units)",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: calculateGWA,
                        child: Text("Calculate GWA"),
                      ),
                      SizedBox(height: 20),

                      // Display GWA Results
                      if (gwa != null)
                        Column(
                          children: [
                            Text("GWA: ${gwa!.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(deanStatus,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
