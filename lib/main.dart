import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'phoneInput.dart';
import 'otp_screen.dart';
import 'auth.dart';
import 'root.dart';
import 'test.dart';
import 'bottom_test.dart';
import 'testing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Bertha login Trial',
      theme: new ThemeData(
          primarySwatch: Colors.blue
      ),
      //home: new Testing(),
      home: new RootPage(auth: new Auth()),
      routes: <String,WidgetBuilder>{
        '/otppage':(BuildContext context)=> OtpInput(),
        '/homepage':(BuildContext context)=> DashboardPage(),
      },
    );
  }
}