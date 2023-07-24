import "package:discord/query/register.dart" as register;
import "package:discord/query/login.dart" as login;
import "package:discord/query/logout.dart" as logout;
import "package:discord/query/create_server.dart" as create;
import "package:discord/query/join_server.dart" as join;
import "package:discord/query/create_channel.dart" as create_ch;
import "package:discord/query/create_cat.dart" as create_cat;
import "package:discord/query/add_r_ch.dart" as add_r_ch;
import "package:discord/query/add_ch_cat.dart" as add_ch_cat;
import "package:discord/query/add_r_cat.dart" as add_r_cat;
import "package:discord/query/send_message.dart" as send;
import "package:discord/query/print_mods.dart" as shows;
import "package:discord/query/print_cats.dart" as cats;
import "package:discord/query/send_dm.dart" as send_dm;
import "package:discord/query/show_dm.dart" as show_dm;
import "package:discord/query/show_ch_mess.dart" as show_ch_mess;
import "dart:io";

void main() async{
   while(true){
    var text="ENTER COMMAND:-";
    print('\x1B[33m$text\x1B[0m');
    var arguments=stdin.readLineSync().toString().split(" ");
    switch(arguments[0]){
      case "register":
        await register.main(arguments);
        break;
      case "login":
        await login.main(arguments);
      case "logout":
        await logout.main(arguments);
      case "creates":
        await create.main(arguments);
      case "join":
        await join.main(arguments);
      case "createc":
         await create_ch.main(arguments);
      case "create_cat":
          await create_cat.main(arguments);
      case "add_r_ch":
          await add_r_ch.main(arguments);
      case "add_ch_cat":
           await add_ch_cat.main(arguments);
      case "add_r_cat":
         await add_r_cat.main(arguments);
      case "send":
         await send.main(arguments);
      case "print":
         await shows.main(arguments);
      case "categories":
          await cats.main(arguments);
      case "send_dm":
          await send_dm.main(arguments);
      case "show_dm":
          await show_dm.main(arguments);
      case "show_ch_mess":
           await show_ch_mess.main(arguments);
      default:
         var text=("NOTT A VALID COMMAND REFER THE README FILE!!");
        print('\x1B[31m$text\x1B[0m');
    }
   }
}