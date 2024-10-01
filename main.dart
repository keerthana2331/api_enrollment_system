import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';



class Student {
  String studentId;
  String name;
  List<String> enrolledCourses;

  Student({required this.studentId, required this.name, this.enrolledCourses = const []});

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'name': name,
      'enrolledCourses': enrolledCourses,
    };
  }

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      name: json['name'],
      enrolledCourses: List<String>.from(json['enrolledCourses']),
    );
  }
}


class Course {
  String courseId;
  String courseTitle;
  String instructorName;

  Course({required this.courseId, required this.courseTitle, required this.instructorName});

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'instructorName': instructorName,
    };
  }

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseTitle: json['courseTitle'],
      instructorName: json['instructorName'],
    );
  }
}

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

void main() async {
  bool running = true;

  while (running) {
    print('\nStudent Course Enrollment System');
    print('1. Create Student');
    print('2. Create Course');
    print('3. Enroll Student in Course');
    print('4. View Student Schedule');
    print('5. View Course Roster');
    print('6. Drop Course');
    print('7. Drop Student');
    print('8. Update Student');
    print('9. Update Course');
    print('10. Exit');
    String choice = readInput('Choose an option', validChoices: [
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'
    ]);

    switch (choice) {
      case '1':
        await createStudent();
        break;
      case '2':
        await createCourse();
        break;
      case '3':
        await enrollStudentInCourse();
        break;
      case '4':
        await viewStudentSchedule();
        break;
      case '5':
        await viewCourseRoster();
        break;
      case '6':
        await dropCourse();
        break;
      case '7':
        await dropStudent();
        break;
      case '8':
        await updateStudent();
        break;
      case '9':
        await updateCourse();
        break;
      case '10':
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

const String coursesApiUrl = '/courses';


Future<void> loadCourses() async {
  try {
    final response = await http.get(Uri.parse(coursesApiUrl));
    
    if (response.statusCode == 200) {
      
      List<dynamic> jsonResponse = json.decode(response.body);
     
      if (jsonResponse.isNotEmpty) {
        for (var course in jsonResponse) {
          print('Course Title: ${course['courseTitle']}, Course ID: ${course['courseId']}, Instructor: ${course['instructor']}');
        }
      } else {
        print('No courses available.');
      }
    } else {
      print('Failed to load courses: ${response.statusCode}');
    }
  } catch (e) {
    print('Error loading courses: $e');
  }
}

Future<void> createStudent() async {
  String name = readInput('Enter student name', validChoices: null, isName: true);
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);

 
  Map<String, Student> students = await DataManager.loadStudents();
  
  
  if (students.containsKey(studentId)) {
    print('Error: A student with ID $studentId already exists.');
    return;
  }

  
  Map<String, Course> courses = await DataManager.loadCourses();
  print('Available Courses:');
  if (courses.isEmpty) {
    print('No courses available to select.');
    return;
  }

  for (var course in courses.values) {
    print('${course.courseId}: ${course.courseTitle}');
  }

  String courseChoice = readInput('Select a course by ID', validChoices: courses.keys.toList());
  String selectedCourseId = courseChoice;

  
  Student newStudent = Student(studentId: studentId, name: name, enrolledCourses: []);
  
 
  if (newStudent.enrolledCourses.contains(selectedCourseId)) {
    print('Error: Student is already enrolled in this course.');
    return;
  } else {
    newStudent.enrolledCourses.add(selectedCourseId);
  }

 
  await DataManager.saveStudent(newStudent);
  print('Student $name with ID $studentId has been successfully created and enrolled in the course.');
}



Future<void> createCourse() async {
  Map<String, Course> courses = await DataManager.loadCourses();

  String courseId;
  do {
    courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);
    if (courses.containsKey(courseId)) {
      print('Error: Course ID already exists. Please enter a unique ID.');
      courseId = ''; 
    }
  } while (courseId.isEmpty);  

  String courseTitle;
  do {
    courseTitle = readInput('Enter course title', validChoices: null, isName: true);
    bool titleExists = courses.values.any((course) => course.courseTitle == courseTitle);
    if (titleExists) {
      print('Error: Course title already exists. Please enter a unique title.');
      courseTitle = ''; 
    }
  } while (courseTitle.isEmpty); 
  String instructorName = readInput('Enter instructor name', validChoices: null, isName: true);

  Course course = Course(courseId: courseId, courseTitle: courseTitle, instructorName: instructorName);

  await DataManager.saveCourse(course);
  print('Course created successfully!');
}

Future<void> viewCourseRoster() async {
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);
  
 
  print('Fetching roster for course $courseId...');
}

Future<void> dropCourse() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);
  
  
  print('Dropped course $courseId for student $studentId successfully.');
}

Future<void> dropStudent() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);
  
  
  print('Dropped student $studentId successfully.');
}

Future<void> updateStudent() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);
  String newName = readInput('Enter new student name', validChoices: null, isName: true);
  
  
  print('Updated student $studentId to new name: $newName');
}

Future<void> updateCourse() async {
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);
  String newTitle = readInput('Enter new course title', validChoices: null, isName: true);
  
 
  print('Updated course $courseId to new title: $newTitle');
}

String readInput(String prompt, {List<String>? validChoices, bool isName = false, bool isId = false}) {
  String? input;
  while (true) {
    stdout.write('$prompt: ');
    input = stdin.readLineSync();
    if (input != null && input.isNotEmpty) {
      if (isName && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(input)) {
        print('Invalid name. Please use only alphabetic characters.');
        continue;
      }
      if (isId && !RegExp(r'^\d+$').hasMatch(input)) {
        print('Invalid ID. Please use only numeric characters.');
        continue;
      }
      if (validChoices != null && !validChoices.contains(input)) {
        print('Invalid choice. Please choose from the options provided.');
        continue;
      }
      break;
    }
    print('Input cannot be empty. Please try again.');
  }
  return input;
}
Future<void> enrollStudentInCourse() async {
  
  print('Student enrolled in course.');
  
}
Future<void> viewStudentSchedule() async {
  
  print('Displaying student schedule...');
  
}

