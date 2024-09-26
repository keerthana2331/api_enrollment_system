import 'dart:convert';

class Student {
  String name;
  String studentId;
  List<String> enrolledCourses;

  Student(this.name, this.studentId, this.enrolledCourses);

  factory Student.fromJson(Map<String, dynamic> json) {

    return Student(
      json['name'] ?? 'Unknown', 
      json['studentId'] ?? 'Unknown', 
      List<String>.from(json['enrolledCourses'] ?? []), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentId': studentId,
      'enrolledCourses': enrolledCourses,
    };
  }
}
