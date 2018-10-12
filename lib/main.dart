import 'package:flutter/material.dart';
import 'strings.dart';
import 'home_page.widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.myAppTitle,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new ListHomePage(title: Strings.myHomePageTitle),
    );
  }
}
