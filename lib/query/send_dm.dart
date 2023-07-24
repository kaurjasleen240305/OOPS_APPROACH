import "package:args/args.dart";
import "package:discord/models/User.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection;

Future<void> main(List<String> arguments) async{
    BaseApi bas=BaseApi();
    Auth auth=Auth();
    DbCollection? users=await bas.coll("Users");
    Map<String,dynamic>? in_session=await auth.session();
     if(in_session!=null){
         var parser=ArgParser();
         parser.addOption("user",abbr:'u');
         parser.addOption("message",abbr:'m');
        var result=parser.parse(arguments);
        User user=User();
        await user.send_dm(result["user"],result["message"],users,in_session);
     }
     else{
        var text=("NOBODY IS LOGGED IN!!");
        print('\x1B[31m$text\x1B[0m');
     }
}