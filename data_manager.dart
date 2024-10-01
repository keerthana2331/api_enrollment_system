import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class DataManager {
  static const String baseUrl = 'https://crudcrud.com/api/dc29a89c50194158834a67e75a4d2395';


  static Future<Map<String, Student>> loadStudents() async {
    Map<String, Student> students = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var student = Student.fromJson(item as Map<String, dynamic>);
          students[student.studentId] = student;
        }
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return students;
  }


  static Future<void> saveStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode == 201) {
        print('Student saved successfully.');
      } else {
        print('Failed to save student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving student: $e');
    }
  }


  static Future<Map<String, Course>> loadCourses() async {
    Map<String, Course> courses = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var course = Course.fromJson(item as Map<String, dynamic>);
          courses[course.courseId] = course;
        }
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return courses;
  }


  static Future<void> saveCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(course.toJson()),
      );
      if (response.statusCode == 201) {
        print('Course saved successfully.');
      } else {
        print('Failed to save course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving course: $e');
    }
  }
}
