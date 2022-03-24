import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:toast/toast.dart';

class HomePage extends StatelessWidget {
  static const TextStyle optionStyle = TextStyle(
      fontSize: 40,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.blue);
  static BuildContext toastContext;

  @override
  Widget build(BuildContext context) {
    toastContext = context;
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
            decoration: BoxDecoration(color: Colors.amber),
            child: Text(Helper.messages[itemIndex].message,
                style: TextStyle(fontSize: 16.0)),
          ),
          options: CarouselOptions(
              height: 220.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              viewportFraction: 1,
              enlargeCenterPage: true),
        ),
        GestureDetector(
            onTap: () => showToast("Hisse1", gravity: Toast.BOTTOM),
            child: Text(
              "Hisse1",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => showToast("Hisse2", gravity: Toast.BOTTOM),
            child: Text(
              "Hisse2",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => showToast("Hisse3", gravity: Toast.BOTTOM),
            child: Text(
              "Hisse3",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => showToast("Hisse4", gravity: Toast.BOTTOM),
            child: Text(
              "Hisse4",
              style: optionStyle,
            )),
        GestureDetector(
            onTap: () => showToast("Hisse5", gravity: Toast.BOTTOM),
            child: Text(
              "Hisse5",
              style: optionStyle,
            )),
      ],
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, toastContext, duration: duration, gravity: gravity);
  }
}
