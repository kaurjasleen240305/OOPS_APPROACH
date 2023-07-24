import "dart:convert";
import "package:crypt/crypt.dart";
import "package:mongo_dart/mongo_dart.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection; 
import "dart:io";
import "package:discord/repeats/auth.dart";
import "package:discord/models/Server.dart";
import "package:discord/models/Category.dart";
import "package:discord/mongo.dart";
import "package:uuid/uuid.dart";


class Channel{
    String? sname;
    String? cname;
    String? ctype;
    List<dynamic>? roles;
    List<dynamic>? category;
    List<dynamic>? c_messages;
    List<String>? all;
    void setter(sname,cname,ctype,roles,category,all){
        this.sname=sname;
        this.cname=cname;
        this.ctype=ctype;
        this.roles=roles;
        this.category=category;
        this.all=all;
    }
    Future<Map<String,dynamic>?> is_channel(String cname,String sname,String ctype,DbCollection? channels) async{
             Map<String,dynamic>? chan;
             await channels?.find().forEach((v){
                if(v["sname"]==sname && v["cname"]==cname && v["ctype"]==ctype){
                    chan=v;
                }
             });
             return chan;
    }

    Future<void> createc(String sname,String cname,String ctype,DbCollection? channels,DbCollection? servers,Map<String,dynamic> sess) async{
            final is_chan=await is_channel(cname,sname,ctype,channels);
            if(is_chan==null){
                Auth auth=Auth();
                String? creator=await auth.creator_Server(servers,sname);
                List<dynamic> roles=[];
                if(ctype=="text" || ctype=="announcement"){
                   roles=[{"role":"newbie"},{"role":"creator"},{"role":"moderator"}];
                }
                else{
                     roles=[{"role":"creator"},{"role":"moderator"}];
                }
            //    print(creator);
                if(creator==sess["username"]){
                    var to_insert={
                        "sname":sname,
                        "cname":cname,
                        "ctype":ctype,
                        "roles":roles,
                        "category":[{"category":null}],
                        "c_messages":[],
                        "all":[sname,cname,ctype],
                    };
                    await channels?.insertOne(to_insert);
                    
                    await servers?.modernUpdate(
                        where.eq('sname',sname),
                        modify.push('channels', {"$cname":ctype})
                    );
                    var text=("CHANNEL IS ADDED SUCCESSFULLY");
                    print('\x1B[32m$text\x1B[0m');
                }
                else{
                    var  text2=("ONLY CREATOR CAN CREATE THE CHANNELS IN THIS SERVER!!!");
                   print('\x1B[31m$text2\x1B[0m');
                }

            }
            else{
                var  text2=("THIS CHANNEL ALREADY EXISTS!!!");
                 print('\x1B[31m$text2\x1B[0mvar');
            }
    }

    Future<void> add_role(String sname,String cname,String ctype,String role,DbCollection? channels,DbCollection? servers,Map<String,dynamic> sess)async{
        final is_chan=await is_channel(cname,sname,ctype,channels);
        if(is_chan!=null){
            Auth auth=Auth();
            String? creator=await auth.creator_Server(servers,sname);
            if(creator==sess["username"]){
                List<String> newrole=[sname,cname,ctype];
                await channels?.modernUpdate(
                where.eq('all',newrole),
                modify.push('roles', {"role":role})
                );
                var  text=("ROLE IS ADDED SUCCESSFULLY!!!");
                print('\x1B[32m$text\x1B[0m');
            }
            else{
                var  text2=("ONLY CREATOR CAN CREATE THE CHANNELS IN THIS SERVER!!!");
                print('\x1B[31m$text2\x1B[0m');
            }
        }
        else{
            var  text2=("THIS CHANNEL DOES NOT EXISTS!!!");
            print('\x1B[31m$text2\x1B[0mvar');
        }
    }

    Future<void> send_message(String sname,String cname,String type,String message,DbCollection? servers,DbCollection? channels,DbCollection? categories,Map<String,dynamic> sess) async{
        final is_chan=await is_channel(cname,sname,type,channels);
        if(is_chan!=null){
            Auth auth=Auth();
            bool match=await auth.user_In_Server(servers,sname,sess["username"]);
            if(match){
               String role=await auth.user_Role_In_Server(servers,sname,sess["username"]);
               int n=is_chan["category"].length;
               var cate=is_chan["category"][n-1]["category"];
               if(cate!=null){
                  Category cat =Category();
                  Map<String,dynamic>? get_c=await cat.get_category(sname,cate,categories);
                  if(get_c!=null){
                  bool match=false;
                      int n=get_c["roles"].length;
                      for(int i=0;i<n;i++){
                        if(get_c["roles"][i]["role"]==role){
                            match=true;
                        }
                      }
                      if(match){
                         List newrole=[sname,cname,type];
                         String user=sess["username"];
                          await channels?.modernUpdate(
                          where.eq('all',newrole),
                         modify.push('cmessages', {"$user":role})
                        );
                       var t=("MESSAGE SENT SUCCESSFULLY TO $cname OF $sname");
                        print('\x1B[32m$t\x1B[0m');
                      } 
                      else{
                        var  text2=("YOU DONT HAVE PERMISSION TO SEND MESSAGE TO THIS CHANNEL!!!");
                        print('\x1B[31m$text2\x1B[0m');
                      }
                  } 
               }
               else{
                  if(type=="text" || type=="announcement"){
                    List newrole=[sname,cname,type];
                    String user=sess["username"];
                    await channels?.modernUpdate(
                     where.eq('all',newrole),
                     modify.push('cmessages', {"$user":role})
                    );
                    var text=("MESSAGE SENT SUCCESSFULLY TO $cname OF $sname");
                     print('\x1B[32m$text\x1B[0m');
                  }
                  else{
                      bool match=false;
                      int n=is_chan["roles"].length;
                      for(int i=0;i<n;i++){
                        if(is_chan["roles"][i]["role"]==role){
                            match=true;
                        }
                      }
                      if(match){
                         List newrole=[sname,cname,type];
                         String user=sess["username"];
                          await channels?.modernUpdate(
                          where.eq('all',newrole),
                         modify.push('cmessages', {"$user":role})
                        );
                       var t=("MESSAGE SENT SUCCESSFULLY TO $cname OF $sname");
                        print('\x1B[32m$t\x1B[0m');
                      } 
                      else{
                        var  text2=("YOU DONT HAVE PERMISSION TO SEND MESSAGE TO THIS CHANNEL!!!");
                        print('\x1B[31m$text2\x1B[0m');
                      }
                  }
               }
            }
            else{
                 var  text2=("YOU ARE NOT THE PART OF THIS SERVER TO SEND MESSAGE!!!");
                print('\x1B[31m$text2\x1B[0m');
            }
        }
        else{
             var  text2=("THIS CHANNEL DOES NOT EXISTS!!!");
            print('\x1B[31m$text2\x1B[0m');
        }
    }

    

}