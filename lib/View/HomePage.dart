import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/View/TestPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const TextStyle optionStyle = TextStyle(
      fontSize: 40,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: Helper.messages.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
            alignment: AlignmentDirectional.center,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color.fromRGBO(0, 160, 227, 1)),
            child: Text(Helper.messages[itemIndex].message,
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
          ),
          options: CarouselOptions(
              height: 220.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              viewportFraction: 1,
              enlargeCenterPage: true),
        ),
        GestureDetector(
            onTap: () => selectedStock("EREGL"),
            child: Text(
              "EREGL",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => selectedStock("TOASO"),
            child: Text(
              "TOASO",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => selectedStock("ISDMR"),
            child: Text(
              "ISDMR",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => selectedStock("FROTO"),
            child: Text(
              "FROTO",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => selectedStock("AKSA"),
            child: Text(
              "AKSA",
              style: optionStyle,
            )),
      ],
    );
  }

  void selectedStock(String message) {
    setState(() {
      Helper.currentHisse = message;
      Helper.selectedIndex = 1;
    });
  }
}
