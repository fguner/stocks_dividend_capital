import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/Controller/ServerConnection.dart';
import 'package:stocks_dividend_capital/Model/DividendAndCapitalType.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool isLoaded = false;
  bool showAvg = false;
  String currentHisse;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> data;

  @override
  void initState() {
    data = new List<FlSpot>();
    currentHisse = Helper.currentHisse;
    Helper.hisseler.sort((a, b) => a.compareTo(b));
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
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration:
                        InputDecoration(hintText: "Başlangıç Yılı (YYYY)"),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Alınan Tutar"),
                  ),
                  Padding(padding: EdgeInsets.all(50)),
                  isLoaded && data.length > 0
                      ? SizedBox(
                          width: 200,
                          height: 200,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 25.0, top: 30),
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
      maxY: (data.last.y)+1,
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
                color: Color.fromARGB(255, 206, 24, 24),
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: (data.first.y) < data.last.y
                      ? Color(0xff8df00c)
                      : Color(0xfff00c0c),
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

  _getDividends() async {
    data = [];
    if (Helper.dividends == null || Helper.dividends.isEmpty) {
      ServerConnection.getDividendData()
          .then((List<DividendAndCapitalType> result) {
        setState(() {
          Helper.dividends = result;
          for (var item in result) {
            if (item.Code == currentHisse &&
                item.Date.year >= DateTime.now().year - 5) {
              data.add(new FlSpot(
                  double.parse(item.Date.year.toString()), item.Dividend));
            }
          }
          isLoaded = true;
        });
      });
    }
  }
}
