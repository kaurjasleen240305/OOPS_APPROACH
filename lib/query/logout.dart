import "package:args/args.dart";
import "package:discord/models/User.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection;

Future<void> main(List<String> arguments) async{
    BaseApi bas=BaseApi();
    Auth auth=Auth();
    DbCollection? sess=await bas.coll("Sessions");
    DbCollection? users=await bas.coll("Users");
    bool sess_exist=await auth.userLoggedIn(sess);
    if(sess_exist){
        var parser=ArgParser();
        parser.addOption("username",abbr:'u');
        var result=parser.parse(arguments);
        User userobj=User();
       await  userobj.logout(result["username"],users,sess);
    }
    else{
        var text=("NOBODY IS LOGGED IN TO LOGOUT!!");
        print('\x1B[31m$text\x1B[0m');
    }

}