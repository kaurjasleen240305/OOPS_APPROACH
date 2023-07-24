import "package:args/args.dart";
import "package:discord/models/Server.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection;

Future<void> main(List<String> arguments) async{
    BaseApi bas=BaseApi();
    Auth auth=Auth();
    DbCollection? servers=await bas.coll("Servers");
    Map<String,dynamic>? in_sess=await auth.session();
    if(in_sess!=null){
        var parser=ArgParser();
        parser.addOption("server",abbr:'s');
        var result=parser.parse(arguments);
        Server ser=Server();
        await ser.show_mods(result["server"],servers);
    }
    else{
        var text=("NOBODY IS LOGGED IN !!");
        print('\x1B[31m$text\x1B[0m');
     } 

}