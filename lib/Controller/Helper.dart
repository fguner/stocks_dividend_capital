import 'package:stocks_dividend_capital/Model/DividendAndCapitalType.dart';
import 'package:stocks_dividend_capital/Model/MessageType.dart';
import 'package:stocks_dividend_capital/Model/StocksType.dart';

class Helper {

  static List<MessageType> messages;
  static List<StocksType> stocks;
  static List<DividendAndCapitalType> dividends;
  static String currentHisse;
  static List<String> hisseler;


  static List<String> getDropDownSearchHisse(var hisse) {
    List<String> items = [];
    for (var item in hisse) {
      items.add(item.Code);
    }
    return items;
  }

}