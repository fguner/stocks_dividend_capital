import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/Controller/ServerConnection.dart';
import 'package:stocks_dividend_capital/Model/DividendAndCapitalType.dart';
import 'package:stocks_dividend_capital/Model/StocksType.dart';
import 'package:stocks_dividend_capital/View/TestPage.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexCarousel = 0, year = 1;
  String Hisse = "", HistoricalAmount = "";
  static const TextStyle optionStyle = TextStyle(
      fontSize: 40,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.blue);
  static const TextStyle infoStyle = TextStyle(
      fontSize: 14,
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
        CarouselSlider.builder(
          itemCount: Helper.stock.length,
          itemBuilder: (BuildContext context, indexCarousel,
                  int pageViewIndex) =>
              Container(
                  alignment: AlignmentDirectional.center,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 160, 227, 1),
                      image: DecorationImage(
                        image: NetworkImage(Helper.stockImage[indexCarousel]),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle)),
          options: CarouselOptions(
            height: 100.0,
            autoPlay: false,
            viewportFraction: 0.20,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              indexCarousel = index;
              setState(() {
                Hisse = Helper.stock[indexCarousel];
                _getDividends();
              });
            },
          ),
        ),
        Text(HistoricalAmount, style: infoStyle),
        Padding(
            padding: EdgeInsets.only(left: 0, top: 50, right: 0, bottom: 0)),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(7)),
            RaisedButton(
                onPressed: () => changeYear(1),
                child: Text('1 Yıl'),
                color:
                    year == 1 ? Colors.green.shade100 : Colors.grey.shade200),
            Padding(padding: EdgeInsets.all(5)),
            RaisedButton(
                onPressed: () => changeYear(2),
                child: Text('2 Yıl'),
                color:
                    year == 2 ? Colors.green.shade100 : Colors.grey.shade200),
            Padding(padding: EdgeInsets.all(5)),
            RaisedButton(
                onPressed: () => changeYear(3),
                child: Text('3 Yıl'),
                color:
                    year == 3 ? Colors.green.shade100 : Colors.grey.shade200),
            Padding(padding: EdgeInsets.all(5)),
            RaisedButton(
                onPressed: () => changeYear(4),
                child: Text('4 Yıl'),
                color:
                    year == 4 ? Colors.green.shade100 : Colors.grey.shade200),
          ],
        )
      ],
    );
  }

  void changeYear(int _year) {
    setState(() {
      year = _year;
    });
    _getDividends();
  }

  _getAmount() async {
    int getLot;
    double lot;

    if(Hisse.isEmpty){
      Hisse = Helper.stock[0];
    }
    Helper.currentHisse = Hisse;
    DateTime date = new DateTime(
        DateTime.now().year - year, DateTime.now().month, DateTime.now().day);

    HistoricalData data;

    ServerConnection.getHistoricalData(DateFormat('MM-yyyy').format(date))
        .then((HistoricalData result) {
      if (result != null) {
        data = result;
        getLot = (1000 ~/ data.Amount);
        lot = getLot.toDouble();

        for (var item in Helper.dividends) {
          if (item.Code == Hisse && item.Date.difference(date).inDays > 0) {
            if (item.TypeCode == "02" ||
                item.TypeCode == "03" ||
                item.TypeCode == "09") {
              double rate = item.CapitalIK + item.CapitalTM;
              lot += (lot * rate) / 100;
            }
          }
        }

        setState(() {
          double current = lot * Helper.last;
          HistoricalAmount = "Eğer 1000 TL " +
              Hisse +
              " yatırımı yapsaydın:\n" +
              current.toStringAsFixed(
                  current.truncateToDouble() == current ? 0 : 2) +
              " TL";
        });
      }
    });
  }

  _getDividends() async {
    ServerConnection.getDividendData()
        .then((List<DividendAndCapitalType> result) {
      setState(() {
        Helper.dividends = result;
        _getAmount();
      });
    });
  }
}
