import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:stocks_dividend_capital/Controller/Helper.dart';
import 'package:stocks_dividend_capital/Model/DividendAndCapitalType.dart';
import 'package:stocks_dividend_capital/Model/MessageType.dart';
import 'package:stocks_dividend_capital/Model/StocksType.dart';
import 'package:http/http.dart' as http;

class ServerConnection {
  static var db, coll;
  static String connectionString =
      "mongodb+srv://fguner:fguner123@dividendandcapital.zz0nh.mongodb.net/DividendAndCapital";

  static void start() async {
    print(connectionString);
    db = await Db.create(connectionString);
    await db.open();
  }

  static void close() async {
    if (db != null) {
      await db.close();
    }
  }

  static Future<void> connectDB(String collectionName) async {
    while (db == null || db.state == State.OPENING) {}

    if (db.state != State.OPEN && db.state != State.OPENING) {
      print(db.state);
      await db.open();
    }

    if (coll == null || coll.collectionName != collectionName) {
      coll = await db.collection(collectionName);
    }
  }

  static Future<List<MessageType>> getMessages() async {
    List<MessageType> list = [];
    if (db == null) {
      await start();
    }

    await connectDB("Message");

    await coll.find().forEach((v) {
      print(v);
      MessageType item = MessageType.fromJson(v);
      list.add(item);
    });
    return list;
  }

  static Future<List<StocksType>> getStocks() async {
    List<StocksType> list = [];
    if (db == null) {
      await start();
    }
    await connectDB("Stocks");
    await coll.find().forEach((v) {
      print(v);
      StocksType item = StocksType.fromJson(v);
      list.add(item);
    });
    return list;
  }

  static Future<List<DividendAndCapitalType>> getDividendData() async {
    List<DividendAndCapitalType> list = [];
    if (db == null) {
      await start();
    }
    await connectDB("DividendAndCapital");
    await coll.find({'Code': Helper.currentHisse}).forEach((v) {
      print(v);
      DividendAndCapitalType item = new DividendAndCapitalType();
      item = DividendAndCapitalType.fromJson(v);

      List<String> splitText = item.CapitalIKString.split('/');
      if (splitText.length > 1) {
        item.CapitalIK =
            double.parse(splitText[0]) / double.parse(splitText[1]);
      } else {
        item.CapitalIK = double.parse(splitText[0]);
      }

      splitText = item.CapitalTMString.split('/');
      if (splitText.length > 1) {
        item.CapitalTM =
            double.parse(splitText[0]) / double.parse(splitText[1]);
      } else {
        item.CapitalTM = double.parse(splitText[0]);
      }

      splitText = item.DividendString.split('/');
      if (splitText.length > 1) {
        item.Dividend = double.parse(splitText[0]) / double.parse(splitText[1]);
      } else {
        item.Dividend = double.parse(splitText[0]);
      }
      list.add(item);
    });
    return list;
  }

  static Future<HistoricalData> getHistoricalData(String date) async {
    HistoricalData data;
    if (db == null) {
      await start();
    }
    await connectDB("HistoricalData");
    var v = await coll
        .findOne({'Code': Helper.currentHisse, 'Date': BsonRegexp(date)});
    if (v != null) {
      data = HistoricalData.fromJson(v);
    }

    await fetchEndeks();
    return data;
  }

  static Future<double> fetchEndeks() async {
    final response = await http.get(Uri.parse(
        'https://www.isyatirim.com.tr/_layouts/15/Isyatirim.Website/Common/Data.aspx/OneEndeks?endeks=' +
            Helper.currentHisse +
            '.E.BIST'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String text = response.body.substring(1, response.body.length - 1);
      EndeksType result = EndeksType.fromJson(jsonDecode(text));
      Helper.last = result.last;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load endeks');
    }
  }
}
