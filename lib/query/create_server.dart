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
        parser.addOption("sname",abbr:'s');
        var result=parser.parse(arguments);
        String s=result["sname"];
        String creator=in_session["username"];
        Server ser_obj=Server();
        final ser_exists=await ser_obj.is_Server(s,servers);
        if(ser_exists==null){
              await ser_obj.creates(s,creator,servers);
              var text=("SERVER CREATED SUCCESSFULLY!!");
             print('\x1B[32m$text\x1B[0m');
        }
        else{
            var text=("SERVER ALREADY EXISTS WITH THIS NAME!!");
            print('\x1B[31m$text\x1B[0m');
        }
    }
    else{
        var text=("NOBODY IS LOGGED IN !!");
        print('\x1B[31m$text\x1B[0m');
    }
}