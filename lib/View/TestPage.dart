import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/Controller/ServerConnection.dart';
import 'package:stocks_dividend_capital/Model/DividendAndCapitalType.dart';
import 'package:stocks_dividend_capital/Model/StocksType.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool isLoaded = false, isClicked = false;
  bool showAvg = false;
  String resultHistorical = "", month;
  int monthIndex = 0;
  final yearControl = TextEditingController();
  final amountControl = TextEditingController();
  String currentHisse;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> data;

  static const TextStyle optionStyle = TextStyle(
      fontSize: 14,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.blue);

  @override
  void initState() {
    currentHisse = Helper.currentHisse;
    Helper.hisseler.sort((a, b) => a.compareTo(b));
    if (currentHisse != "") {
      _getDividends();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: ListBody(
            children: <Widget>[
              ListBody(
                children: <Widget>[
                  DropdownSearch(
                    showSearchBox: true,
                    label: currentHisse != null && currentHisse != 'Hisse'
                        ? currentHisse
                        : 'Hisse',
                    selectedItem: currentHisse,
                    items: Helper.hisseler,
                    showClearButton: true,
                    onChanged: changedDropDownHisse,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  DropdownSearch(
                    showSearchBox: true,
                    label: month != null && month != 'Ay' ? month : 'Ay',
                    selectedItem: month,
                    items: Helper.months,
                    showClearButton: true,
                    onChanged: changedDropDownMonth,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    maxLength: 4,
                    controller: yearControl,
                    decoration:
                        InputDecoration(hintText: "Başlangıç Tarihi (YYYY)"),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: amountControl,
                    decoration: InputDecoration(hintText: "Alınan Tutar(TL)"),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          side: BorderSide(
                              color: Color.fromRGBO(0, 160, 227, 1))),
                      onPressed: () => _getAmount(),
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white,
                      textColor: Color.fromRGBO(0, 160, 227, 1),
                      child: Text("Hesapla", style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 15, top: 10)),
                  Text(
                    resultHistorical,
                    style: optionStyle,
                  ),
                  isClicked
                      ? Center(child: CircularProgressIndicator(strokeWidth: 2))
                      : Padding(padding: EdgeInsets.all(0)),
                  isLoaded && data.length > 0
                      ? ListBody(
                          children: <Widget>[
                            const Text(
                              'Temettü Geçmişi',
                              style: TextStyle(
                                color: Color.fromARGB(255, 44, 173, 233),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                                width: 200,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 25.0, top: 10),
                                  child: LineChart(mainData()),
                                )),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              right: 0, left: 0, top: 0, bottom: 0))
                ],
              ),
            ],
          )),
    );
  }

  void changedDropDownHisse(String selectedHisse) {
    setState(() {
      isLoaded = false;
      Helper.dividends = [];
      resultHistorical = "";
      currentHisse = selectedHisse != null ? selectedHisse : 'Hisse';
      currentHisse = currentHisse.split("-")[0].trim();
      Helper.currentHisse = currentHisse;
      _getDividends();
    });
  }

  void changedDropDownMonth(String month) {
    setState(() {
      this.month = month != null ? month : 'Ay';
      monthIndex = Helper.months.indexWhere((element) => element == month);
    });
  }

//Veriler üzerinden grafiği çizmek için oluşturuldu.
  LineChartData mainData() {
    int amountCompare(u1, u2) => u2['y'] - u1['y'];
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return value.toString().split('.')[0];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: data.first.x,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: data,
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors,
          ),
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.white,
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.grey,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${flSpot.y} TL',
                  const TextStyle(
                      color: Colors.black87,
                      fontFamily: 'NeueMontreal',
                      fontWeight: FontWeight.w600,
                      fontSize: 10),
                );
              }).toList();
            }),
      ),
    );
  }

  _getAmount() async {
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      resultHistorical = "";
      isClicked = true;
    });
    int year = int.tryParse(yearControl.text);
    int amount = int.tryParse(amountControl.text);
    int getLot;
    double lot, dividend = 0;
    String ay = (monthIndex + 1).toString();
    ay = ay.length < 2 ? ay.replaceAll(ay, "0" + ay) : ay;

    if (year == null || amount == null) {
      Toast.show("Lütfen yıl ve tutar bilgilerini girin", context);
      setState(() {
        isClicked = false;
      });
      return;
    }

    DateTime date =
        new DateTime(year, DateTime.now().month, DateTime.now().day);
    HistoricalData data;

    ServerConnection.getHistoricalData(DateFormat(ay + '-yyyy').format(date))
        .then((HistoricalData result) {
      if (result != null) {
        data = result;
        getLot = (amount ~/ data.Amount);
        lot = getLot.toDouble();

        for (var item in Helper.dividends) {
          if (item.Code == currentHisse &&
              item.Date.difference(date).inDays > 0) {
            if (item.TypeCode == "02" ||
                item.TypeCode == "03" ||
                item.TypeCode == "09") {
              double rate = item.CapitalIK + item.CapitalTM;
              lot += (lot * rate) / 100;
            } else {
              dividend += (lot * item.Dividend);
            }
          }
        }

        setState(() {
          double current = lot * Helper.last;
          resultHistorical =month.toString() + " " + year.toString() +"'da;\n"+
              amount.toString() + " TL ile " + getLot.toString() + " lot alınsaydı;\nŞu anda " +
              lot.toStringAsFixed(lot.truncateToDouble() == current ? 0 : 2) +
              " lot karşılığı " + (current).toStringAsFixed(current.truncateToDouble() == current ? 0 : 2) +
              " TL değerinde hisse olacaktı," +
              "\nŞimdiye kadar " +
              dividend.toStringAsFixed(
                  dividend.truncateToDouble() == current ? 0 : 2) +
              " TL temettü alınacaktı.\n\n";
        });
        setState(() {
          isClicked = false;
        });
        return;
      } else {
        setState(() {
          isClicked = false;
        });
        Toast.show("O tarihe ait veri bulunamadı", context);
      }
    });
  }

  _getDividends() async {
    data = [];
    ServerConnection.getDividendData()
        .then((List<DividendAndCapitalType> result) {
      setState(() {
        Helper.dividends = result;
        for (var item in result) {
          if (item.Code == currentHisse &&
              item.Date.year >= DateTime.now().year - 5 &&
              item.TypeCode == "04") {
            if (data.any((element) => element.x == item.Date.year)) {
              double year =
                  data.firstWhere((element) => element.x == item.Date.year).x;
              double result =
                  data.firstWhere((element) => element.x == item.Date.year).y;
              result += item.Dividend;
              data.removeWhere((element) => element.x == year);
              data.add(
                  new FlSpot(double.parse(item.Date.year.toString()), result));
            } else {
              data.add(new FlSpot(
                  double.parse(item.Date.year.toString()), item.Dividend));
            }
          }
        }
        isLoaded = true;
      });
    });
  }
}
