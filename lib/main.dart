
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/View/ContainerPage.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main(){
HttpOverrides.global = new MyHttpOverrides();

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => ContainerPage()
    }
  ));
}
