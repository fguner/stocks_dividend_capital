import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/Model/MessageType.dart';
import 'package:stocks_dividend_capital/Model/StocksType.dart';
import 'package:stocks_dividend_capital/View/HomePage.dart';
import 'package:stocks_dividend_capital/Controller/ServerConnection.dart';
import 'package:stocks_dividend_capital/View/TestPage.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({Key key}) : super(key: key);

  static const String _title = 'FinEst';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      color: Color.fromRGBO(0, 160, 227, 1),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isLoaded = false;
  List<Widget> _widgetOptions = [];

  _getMessages() async {
    setState(() {
      isLoaded = false;
    });

    Helper.stock = new List<String>();
    Helper.stock.add("TOASO");
    Helper.stock.add("EREGL");
    Helper.stock.add("ALARK");
    Helper.stock.add("FROTO");
    Helper.stock.add("ISDMR");
    Helper.stock.add("HEKTS");

    Helper.stockImage = new List<String>();
    Helper.stockImage.add("https://www.gcmyatirim.com.tr/wp-content/uploads/borsa/toaso_1624535397.png");
    Helper.stockImage.add("https://www.gcmyatirim.com.tr/wp-content/uploads/2021/02/26/eregl_1614330642.png");
    Helper.stockImage.add("https://www.gcmyatirim.com.tr/wp-content/uploads/borsa/alark_1623744328.png");
    Helper.stockImage.add("https://www.gcmyatirim.com.tr/wp-content/uploads/borsa/froto_1624272498.png");
    Helper.stockImage.add("https://s3-symbol-logo.tradingview.com/iskenderun-demir-celik--600.png");
    Helper.stockImage.add("https://s3-symbol-logo.tradingview.com/hektas--600.png");

    if (Helper.messages == null || Helper.messages.isEmpty) {
      ServerConnection.getMessages().then((List<MessageType> result) {
        setState(() {
          isLoaded = true;
          Helper.messages = result;
          changeScreen();
        });
      });
    } else {
      setState(() {
        isLoaded = true;
        Helper.messages = Helper.messages;
        changeScreen();
      });
    }
  }

  _getStocks() async {
    setState(() {
      isLoaded = false;
    });

    if (Helper.stocks == null || Helper.stocks.isEmpty) {
      ServerConnection.getStocks().then((List<StocksType> result) {
        setState(() {
          Helper.stocks = result;
          Helper.hisseler = Helper.getDropDownSearchHisse(Helper.stocks);
          changeScreen();
        });
      });
    }
  }

  @override
  void initState() {
    changeScreen();
    _getMessages();
    _getStocks();
    super.initState();
  }

  void changeScreen() {
    _widgetOptions = <Widget>[
      isLoaded
          ? HomePage()
          : Center(child: CircularProgressIndicator(strokeWidth: 2)),
      Helper.hisseler != null
          ? TestPage()
          : Center(child: CircularProgressIndicator(strokeWidth: 2)),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      Helper.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinEst'),
        backgroundColor: Color.fromRGBO(0, 160, 227, 1),
      ),
      body: Container(child: _widgetOptions.elementAt(Helper.selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Hisseler',
          )
        ],
        currentIndex: Helper.selectedIndex,
        selectedItemColor: Color.fromARGB(255, 3, 89, 125),
        onTap: _onItemTapped,
      ),
    );
  }
}
