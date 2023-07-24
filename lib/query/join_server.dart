import "package:args/args.dart";
import "package:discord/models/Server.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection;

Future<void> main(List<String> arguments) async{
     BaseApi bas=BaseApi();
     Auth auth=Auth();
     DbCollection? servers=await bas.coll("Servers");
     Map<String,dynamic>? in_session=await auth.session();
     if(in_session!=null){
          var parser=ArgParser();
          parser.addOption("server",abbr:'s');
          parser.addOption("uname",abbr:'u');
          parser.addOption("role",abbr:'r');
          var result=parser.parse(arguments);
          Server ser_obj=Server();
          await ser_obj.joins(result["server"],result["uname"],result["role"],servers,in_session);

     }
     else{
        var text=("NOBODY IS LOGGED IN!!");
        print('\x1B[31m$text\x1B[0m');
     }
}