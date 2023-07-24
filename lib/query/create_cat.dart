import "package:args/args.dart";
import "package:discord/models/Category.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection;
Future<void> main(List<String> arguments) async{
    BaseApi bas=BaseApi();
    Auth auth=Auth();
    DbCollection? channs=await bas.coll("Categories");
    DbCollection? servers=await bas.coll("Servers");
    Map<String,dynamic>? in_session=await auth.session();
    if(in_session!=null){
        var parser=ArgParser();
        parser.addOption("server",abbr:'s');
        parser.addOption("cat_name",abbr:'c');
  //      parser.addOption("type",abbr:'t');
        var result=parser.parse(arguments);
        Category cat=Category();
        await cat.create_cat(result["server"],result["cat_name"],channs,servers,in_session);
    }
    else{
        var text=("NOBODY IS LOGGED IN !!");
        print('\x1B[31m$text\x1B[0m');
    }
}