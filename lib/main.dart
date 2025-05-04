import 'package:cash_denomination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/home/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cash Denomination',
      theme: customLightTheme,
      themeMode: ThemeMode.light,
      home: HomeView(),
    );
  }
}
 final ThemeData customLightTheme = ThemeData(
  primaryColor: Colors.lightBlue.shade800,
  scaffoldBackgroundColor: whiteC,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.lightBlue.shade800,
    foregroundColor: whiteC,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: whiteC,
    ),
    iconTheme: IconThemeData(color: whiteC),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: whiteC),
    bodyMedium: TextStyle(fontSize: 14, color: whiteC),
  ),
  cardTheme: CardTheme(
    color: whiteC,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  iconTheme: IconThemeData(color: Colors.lightBlue.shade800),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.lightBlue.shade800,
    foregroundColor: whiteC,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.lightBlue.shade800,
      foregroundColor: whiteC,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

