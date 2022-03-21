import 'package:mongo_dart/mongo_dart.dart';
import 'package:stocks_dividend_capital/Model/MessageType.dart';

var db,coll;

void start() async {
  const String connectionString ="Your connection string";
  
  if(db == null){
    db = await Db.create(connectionString);
  }
}

void close() async {
  if(db != null){
    await db.close();
  }
}

void open() async{
  if(db != null){
    await db.open();
  } else{
    start();
    open();
  }
}

Future<void> connectDB(String collectionName) async {

  if(db.state != State.OPEN && db.state != State.OPENING ){
    print(db.state);
    await db.open();
  }
  while(db.state == State.OPENING){
    
  }

  if(coll == null || coll.collectionName != collectionName){
    coll = await db.collection(collectionName);
  }
  
}


Future<List<MessageType>> getPortfolio(String macAddress) async {
  
  List<MessageType> list = [];

  await connectDB("Message");

  await coll.find().forEach((v) {
    print(v);
    MessageType item = MessageType.fromJson(v);
      list.add(item);
  });
  return list;
}


