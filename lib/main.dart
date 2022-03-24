import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/View/ContainerPage.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => ContainerPage()
    }
  ));
}
