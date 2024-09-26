import 'dart:convert';

class Course {
  String courseId;
  String courseTitle;
  String instructorName;
  List<String> enrolledStudents;

  Course(this.courseId, this.courseTitle, this.instructorName, this.enrolledStudents);

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      json['courseId'] ?? 'Unknown', 
      json['courseTitle'] ?? 'Unknown', 
      json['instructorName'] ?? 'Unknown', 
      List<String>.from(json['enrolledStudents'] ?? []), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'instructorName': instructorName,
      'enrolledStudents': enrolledStudents,
    };
  }
}
