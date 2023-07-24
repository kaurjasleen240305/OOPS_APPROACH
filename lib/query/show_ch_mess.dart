import "package:args/args.dart";
import "package:discord/models/Channel.dart";
import "package:discord/repeats/auth.dart";
import "package:discord/repeats/db.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection;

Future<void> main(List<String> arguments) async{
    BaseApi bas=BaseApi();
    Auth auth=Auth();
    DbCollection? channs=await bas.coll("Channels");
    DbCollection? servers=await bas.coll("Servers");
    Map<String,dynamic>? in_session=await auth.session();
     if(in_session!=null){
         var parser=ArgParser();
         parser.addOption("server",abbr:'s');
         parser.addOption("channel",abbr:'c');
         parser.addOption("type",abbr:'t');
         parser.addOption("line",abbr:'l');
         var result=parser.parse(arguments);
         int l=int.parse(result["line"]);
         Channel chan=Channel();
         await chan.show_ch_messages(result["server"],result["channel"],result["type"],l,channs,servers,in_session);
     }
      else{
        var text=("NOBODY IS LOGGED IN !!");
        print('\x1B[31m$text\x1B[0m');
     }
}