import "package:args/args.dart";
import "package:discord/models/User.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:discord/mongo.dart";
import "package:mongo_dart/mongo_dart.dart" show Db, DbConnection,DbCollection;

Future<void> main(List<String> arguments) async{
   // print("Hi");
    BaseApi bas=BaseApi();
    DbCollection? users=await bas.coll("Users");
    DbCollection? sess=await  bas.coll("Sessions");
   // (sess);
    Auth auth=Auth();
    bool is_session=await auth.userLoggedIn(sess);
  //  print(is_session);
   // print(is_session);
    if(!is_session){
         var parser=ArgParser();
         parser.addOption("username",abbr:'u');
         var result=parser.parse(arguments);
         bool user_exists=await auth.userExists(result["username"],users);
         if(!user_exists){
                User user=User();
                await user.register(result["username"],users);
         }
         else{
            var text=("USER ALREADY EXISTS WITH THIS USERNAME");
            print('\x1B[31m$text\x1B[0m');
         }
    }
    else{
        var text=("SOMEONE IS ALREADY LOGGED IN !!");
        print('\x1B[31m$text\x1B[0m');
    }
    

    
}