import '../models/subject.dart';

class GwaController {
  final List<Subject> subjects = [
    // 1st Year - 1st Sem
    Subject(name: 'AP1', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'CC 111', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'CC 112', units: 2, yearLevel: '1st', semester: '1st'),
    Subject(name: 'CC 112L', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'GEC-MMW', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'GEC-RPH', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'GEE-TEM', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'NSTP 1', units: 3, yearLevel: '1st', semester: '1st'),
    Subject(name: 'PE1', units: 2, yearLevel: '1st', semester: '1st'),

    
    // 1st Year - 2nd Sem
    Subject(name: 'AP2', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'CC 123', units: 2, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'CC 123L', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'GEC-PC', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'GEC-STS', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'GEC-US', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'GEE-GSPS', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'NSTP 2', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'PC 121', units: 3, yearLevel: '1st', semester: '2nd'),
    Subject(name: 'PE2', units: 2, yearLevel: '1st', semester: '2nd'),


    // 2nd Year - 1st Sem
    Subject(name: 'GEC-E', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'GEE-ES', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'GEC-LWR', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'PC 212', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'CC 214', units: 2, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'CC 214L', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'P ELEC 1', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'E ELEC 2', units: 3, yearLevel: '2nd', semester: '1st'),
    Subject(name: 'PE3', units: 2, yearLevel: '2nd', semester: '1st'),



    // 2nd Year - 2nd Sem
    Subject(name: 'GEC-TCW', units: 3, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'PC 223', units: 3, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'PC 224', units: 3, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'CC 225', units: 2, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'CC 225L', units: 3, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'P ELEC 3', units: 3, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'AP 3', units: 3, yearLevel: '2nd', semester: '2nd'),
    Subject(name: 'PE 4', units: 2, yearLevel: '2nd', semester: '2nd'),


    // 3rd Year - 1st Sem
    Subject(name: 'GEE-FE', units: 3, yearLevel: '3rd', semester: '1st'),
    Subject(name: 'PC 315', units: 2, yearLevel: '3rd', semester: '1st'),
    Subject(name: 'PC 315L', units: 3, yearLevel: '3rd', semester: '1st'),
    Subject(name: 'PC 316', units: 3, yearLevel: '3rd', semester: '1st'),
    Subject(name: 'PC 317', units: 3, yearLevel: '3rd', semester: '1st'),
    Subject(name: 'PC 3180', units: 3, yearLevel: '3rd', semester: '1st'),
    Subject(name: 'CC 316', units: 3, yearLevel: '3rd', semester: '1st'),



    // 3rd Year - 2nd Sem
    Subject(name: 'GEC-AA', units: 3, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'GEE-PEE', units: 3, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'PC 329', units: 3, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'PC 3210', units: 3, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'PC 3211', units: 2, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'PC 3211L', units: 3, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'AP 4', units: 3, yearLevel: '3rd', semester: '2nd'),
    Subject(name: 'AP 5', units: 3, yearLevel: '3rd', semester: '2nd'),


    // 4th Year - 1st Sem
    Subject(name: 'PC 4112', units: 2, yearLevel: '4th', semester: '1st'),
    Subject(name: 'PC 4112L', units: 3, yearLevel: '4th', semester: '1st'),
    Subject(name: 'PC 4113', units: 3, yearLevel: '4th', semester: '1st'),
    Subject(name: 'PC 4114', units: 3, yearLevel: '4th', semester: '1st'),
    Subject(name: 'P ELEC 4', units: 3, yearLevel: '4th', semester: '1st'),
    Subject(name: 'AP 6', units: 3, yearLevel: '4th', semester: '1st'),


    // 4th Year - 2nd Sem
    Subject(name: 'PC 4215', units: 9, yearLevel: '4th', semester: '2nd')
  ];

  List<Subject> getSubjects(String year, String sem) {
    return subjects.where((sub) => sub.yearLevel == year && sub.semester == sem).toList();
  }

  // double calculateGWA(Map<String, double> grades, List<Subject> selectedSubjects) {
  //   double totalWeightedGrades = 0;
  //   double totalUnits = 0;

  //   for (var subject in selectedSubjects) {
  //     if (grades.containsKey(subject.name)) {
  //       totalWeightedGrades += subject.units * grades[subject.name]!;
  //       totalUnits += subject.units;
  //     }
  //   }

  //   return totalUnits == 0 ? 0 : totalWeightedGrades / totalUnits;
  // }

  double calculateGWA(Map<String, double> grades, List<Subject> selectedSubjects) {
    double totalWeightedGrades = 0;
    double totalUnits = 0;

    for (var subject in selectedSubjects) {
      if (grades.containsKey(subject.name)) {
        // Exclude NSTP 1 and NSTP 2 from GWA computation
        if (subject.name != 'NSTP 1' && subject.name != 'NSTP 2') {
          totalWeightedGrades += subject.units * grades[subject.name]!;
          totalUnits += subject.units;
        }
      }
    }

    return totalUnits == 0 ? 0 : totalWeightedGrades / totalUnits;
  }

  // String getDeanStatus(double gwa, Map<String, double> grades) {
  //   // Check if any subject has a grade of 2.6 or below
  //   bool hasLowGrade = grades.values.any((grade) => grade >= 2.6);

  //   if (gwa <= 1.75 && !hasLowGrade) {
  //     return "Dean's Lister ✅";
  //   } else {
  //     return "Not a Dean's Lister ❌";
  //   }
  // }

  String getDeanStatus(double gwa, Map<String, double> grades) {
    // Check if any grade is 2.6 or above, including NSTP
    bool hasLowGrade = grades.entries.any((entry) {
      // Consider NSTP grades for disqualification
      return entry.value >= 2.6;
    });

    if (gwa <= 1.75 && !hasLowGrade) {
      return "Dean's Lister ✅";
    } else {
      return "Not a Dean's Lister ❌";
    }
  }

  // ANG MGA GIPANG COMMENT KATONG SA NSTP

}
