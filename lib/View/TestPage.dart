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
  bool isLoaded = false;
  bool showAvg = false;
  String resultHistorical = "";
  final yearControl = TextEditingController();
  final amountControl = TextEditingController();
  String currentHisse;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> data;

  static const TextStyle optionStyle = TextStyle(
      fontSize: 20,
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
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 0, left: 15, top: 20, bottom: 0)),
                  Text(
                    resultHistorical,
                    style: optionStyle,
                  ),
                  Padding(padding: EdgeInsets.all(25)),
                  isLoaded && data.length > 0
                      ? SizedBox(
                          width: 300,
                          height: 250,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 25.0, top: 50),
                            child: LineChart(mainData()),
                          ),
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
      currentHisse = selectedHisse != null ? selectedHisse : 'Hisse';
      currentHisse = currentHisse.split("-")[0].trim();
      Helper.currentHisse = currentHisse;
      _getDividends();
    });
  }

//Veriler üzerinden grafiği çizmek için oluşturuldu.
  LineChartData mainData() {
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
      maxX: data.last.x,
      minY: 0,
      maxY: (data.last.y) + 1,
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
    int year = int.tryParse(yearControl.text);
    int amount = int.tryParse(amountControl.text);
    int lot;

    if (year == null || amount == null) {
      Toast.show("Lütfen yıl ve tutar bilgilerini girin", context);
      return;
    }

    DateTime date =
        new DateTime(year, DateTime.now().month, DateTime.now().day);
    HistoricalData data;

    ServerConnection.getHistoricalData(DateFormat('dd-MM-yyyy').format(date))
        .then((HistoricalData result) {
      if (result.Amount == null) {
        ServerConnection.getHistoricalData(DateFormat('dd-MM-yyyy')
                .format(date.add(const Duration(days: 1))))
            .then((HistoricalData result1) {
          if (result1.Amount == null) {
            ServerConnection.getHistoricalData(DateFormat('dd-MM-yyyy')
                    .format(date.add(const Duration(days: 2))))
                .then((HistoricalData result2) {
              if (result2.Amount != null) {
                data = result2;
                lot = (amount ~/ data.Amount);
                Toast.show((lot * 85.85).toString(), context);
                setState(() {
                  resultHistorical = year.toString() +
                      " yılında alınan " +
                      lot.toString() +
                      " adetin şuanki fiyatı:" +
                      (lot * 85.85).toString();
                });
                return;
              } else {
                Toast.show("O Tarihe ait hisse değeri bulunamadı.", context);
                return;
              }
            });
          } else {
            data = result1;
            lot = (amount ~/ data.Amount);
            Toast.show((lot * 85.85).toString(), context);
            setState(() {
              resultHistorical = year.toString() +
                  " yılında alınan " +
                  lot.toString() +
                  " adetin şuanki fiyatı:" +
                  (lot * 85.85).toString();
            });
            return;
          }
        });
      } else {
        data = result;
        lot = (amount ~/ data.Amount);
        Toast.show((lot * 85.85).toString(), context);
        setState(() {
          resultHistorical = year.toString() +
              " yılında alınan " +
              lot.toString() +
              " adetin şuanki fiyatı:" +
              (lot * 85.85).toString();
        });
        return;
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
            data.add(new FlSpot(
                double.parse(item.Date.year.toString()), item.Dividend));
          }
        }
        isLoaded = true;
      });
    });
  }
}
