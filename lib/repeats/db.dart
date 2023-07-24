import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection,DbConnection;
import "package:mongo_dart/mongo_dart.dart";
import 'package:discord/mongo.dart';
import 'dart:async';


class BaseApi{
   
    BaseApi();

   Future<DbCollection?> coll(String t) async{
     DBConnection db= DBConnection();
   //  print(db);
     Db? x= await db.getConnection();
   //  print(x);
     var ans=await x?.collection("$t");
     return ans;
   }

}