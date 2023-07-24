import "package:mongo_dart/mongo_dart.dart" show Db, DbConnection;
import 'dart:io';
import 'dart:async';


class DBConnection{
   static late DBConnection _instance;

   final String _host="localhost";
   final int _port=27017;
   final String _dbName="Darty";

   Db? _db;
   static getInstance(){
    if(_instance==null){
      _instance=DBConnection();
    }
    return _instance;
   }
   Future<Db?> getConnection() async{
    if(_db==null){
      try{
        _db= Db(_getConnectionString());
        await _db?.open();
      }catch(e){
        print(e);
      }
    }
    return _db;
   }
   _getConnectionString(){
    return "mongodb://$_host:$_port/$_dbName";
   }
   closeConnection(){
    _db?.close();
   }
}
