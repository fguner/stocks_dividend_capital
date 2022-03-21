import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/View/ContainerPage.dart';
import './View/HomePage.dart';
import './View/TestPage.dart';

void main() {
  //runApp(HomePage());
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => ContainerPage()
    }
  ));
}
