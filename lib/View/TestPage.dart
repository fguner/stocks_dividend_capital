import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hisse giriş'),
      content: SingleChildScrollView(
          child: ListBody(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Lot Sayısı"),
          ),
          TextFormField(
            // ignore: missing_return
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Maliyetiniz"),
          ),
        ],
      )),
      actions: <Widget>[
        TextButton(
            child: Text('Onayla'), onPressed: () => Toast.show("ISDMR", context)
            //((Navigator.of(context).pop();
            ),
      ],
    );
  }
}
