import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:toast/toast.dart';

class StocksPage extends StatefulWidget {
  @override
  _StocksPageState createState() => new _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  bool isLoaded = true;
  String currentHisse;

  @override
  void initState() {
    currentHisse = Helper.currentHisse;
    Helper.hisseler.sort((a, b) => a.compareTo(b));
    super.initState();
  }

  void addItem() {
    Toast.show("Deneme", context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
          child: isLoaded
              ? ListBody(
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
                      decoration: InputDecoration(hintText: "Başlangıç Tarihi (GG/AA/YYYY)"),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Alınan Tutar"),
                    ),
                  ],
                )
              : SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  height: 250.0,
                  width: 250.0,
                )),
    );
  }

  void changedDropDownHisse(String selectedHisse) {
    setState(() {
      currentHisse = selectedHisse != null ? selectedHisse : 'Hisse';
      currentHisse = currentHisse.split("-")[0].trim();
    });
  }
}
