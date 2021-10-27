import 'package:flutter/material.dart';
import 'package:student_portal_app/HomePage/Admin_Portal/Faculty_Attendance_card/FacultyList/facultyList.dart';
import 'package:student_portal_app/HomePage/Faculty/faculty_LogIn.dart';
import 'package:student_portal_app/Splashpage/SplashPage.dart';

import 'HomePage/Admin_Portal/Fees_Card/upload_Expenses_Request/upload_expenses_request.dart';
import 'HomePage/Admin_Portal/Student_card/Student_search_card/StudentSearchCard.dart';
import 'HomePage/Admin_Portal/Student_card/Student_search_card/studentAlldetail/studentDetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(
      scaffoldBackgroundColor: Color(0xFFBCEBEB),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF097272)
      )
    ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      // home: FacultyLogIn()
    );
  }
}
