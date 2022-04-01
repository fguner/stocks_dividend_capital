import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/Model/MessageType.dart';
import 'package:stocks_dividend_capital/View/HomePage.dart';
import 'package:stocks_dividend_capital/Controller/ServerConnection.dart';
import 'package:stocks_dividend_capital/View/StocksPage.dart';
import 'package:stocks_dividend_capital/View/TestPage.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({Key key}) : super(key: key);

  static const String _title = 'FinEst';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      color: Colors.orange,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>{
  int _selectedIndex = 0;
  bool isLoaded = false;
  static List<MessageType> messages = [];
  static String mesaj = "";
  List<Widget> _widgetOptions = [];

  _getMessages() async {
    setState(() {
      isLoaded = false;
    });

    if (Helper.messages == null || Helper.messages.isEmpty) {
      ServerConnection.getMessages().then((List<MessageType> result) {
        setState(() {
          isLoaded = true;
          Helper.messages = result;
          mesaj = result[0].message;
          changeScreen();
        });
      });
    } else {
      setState(() {
        isLoaded = true;
        messages = Helper.messages;
        mesaj = messages[0].message;
        changeScreen();
      });
    }
  }

  _insertStocks(){
    Helper.hisseler = new List();
    Helper.hisseler.add("TOASO");
    Helper.hisseler.add("EREGL");
    Helper.hisseler.add("FROTO");
    Helper.hisseler.add("ISMDR");
  }
  
  @override
  void initState() {
    changeScreen();
    _getMessages();
    _insertStocks();
    super.initState();
  }

  void changeScreen() {
    TextStyle optionStyle = TextStyle(
        fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue);
   _widgetOptions = <Widget>[
      isLoaded ? HomePage() : Center(child : CircularProgressIndicator(strokeWidth: 2)),
      StocksPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinEst'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
