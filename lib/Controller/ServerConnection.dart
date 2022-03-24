import 'package:mongo_dart/mongo_dart.dart';
import 'package:stocks_dividend_capital/Model/MessageType.dart';
  
class ServerConnection{

static var db,coll;
static String connectionString ="Your connection string";

static void start() async {
    print(connectionString);
    db = await Db.create(connectionString);
    await db.open();
}

static void close() async {
  if(db != null){
    await db.close();
  }
}

static Future<void> connectDB(String collectionName) async {

  while(db == null || db.state == State.OPENING){
    
  }

  if(db.state != State.OPEN && db.state != State.OPENING ){
    print(db.state);
    await db.open();
  }

  if(coll == null || coll.collectionName != collectionName){
    coll = await db.collection(collectionName);
  }
  
}


static Future<List<MessageType>> getMessages() async {
  
  List<MessageType> list = [];
  if(db == null){
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

}
