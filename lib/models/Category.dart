import "dart:convert";
import "package:crypt/crypt.dart";
import "package:mongo_dart/mongo_dart.dart";
import "package:mongo_dart/mongo_dart.dart" show Db,DbCollection; 
import "dart:io";
import "package:discord/repeats/auth.dart";
import "package:discord/models/Server.dart";
import "package:discord/mongo.dart";
import "package:uuid/uuid.dart";


class Category{
    String? sname;
    String? cat_name;
    List<String>? channels;
    List<String>? roles;
    List<dynamic>? all;
    
    void setter(sname,cat_name,roles,channels){
        this.sname=sname;
        this.cat_name=cat_name;
        this.roles=roles;
        this.channels=channels;
    }
    Future<bool> is_category(String sname,String cat_name,DbCollection? categories) async{
        bool match=false;
        await categories?.find().forEach((v){
            if(v["sname"]==sname && v["cat_name"]==cat_name){
                match=true;
            };
        });
        return match;
    }
     Future<Map<String,dynamic>?> get_category(String sname,String cat_name,DbCollection? categories) async{
         Map<String,dynamic>? cat;
        await categories?.find().forEach((v){
            if(v["sname"]==sname && v["cat_name"]==cat_name){
                cat=v;
            };
        });
        return cat;
    }
    Future<void> create_cat(String sname,String cat_name,DbCollection? categories,DbCollection? servers,Map<String,dynamic> sess) async{
        bool match=await is_category(sname,cat_name,categories);
        if(!match){
            Auth auth=Auth();
            String? creator=await auth.creator_Server(servers,sname);
            if(creator==sess["username"]){
                  var to_insert={
                    "sname":sname,
                    "cat_name":cat_name,
                    "roles":[],
                    "channels":[],
                    "all":[sname,cat_name],
                  };
                 await  categories?.insertOne(to_insert);
                  var text=("CATEGORY IS ADDED SUCCESSFULLY");
                 print('\x1B[32m$text\x1B[0m');
            }
            else{
                var text=("ONLY CREATOR CAN ADD A CATEGORY");
                print('\x1B[31m$text\x1B[0m');
            }
        }
        else{
            var text="ALREADY A CATEGORY EXISTS IN THIS SERVER ";
            print('\x1B[31m$text\x1B[0m');
        }
   
    }
    Future<void> add_channel(String sname,String cat,String cname,DbCollection? servers,DbCollection? channels,DbCollection? categories,Map<String,dynamic> sess)async{
        bool match=await is_category(sname,cat,categories);
        if(match){
            Auth auth=Auth();
            String? creator=await auth.creator_Server(servers,sname);
            if(creator==sess["username"]){
                 List<String> newall=[sname,cat];
                await categories?.modernUpdate(
                where.eq('all',newall),
                modify.addToSet('channels', cname)
                );
                await channels?.modernUpdate(
                    where.eq('cname',cname),
                    ModifierBuilder().set('category',cat)
                );
                var text=("CHANNEL ADDED SUCCESSFULLY TO $cname OF $sname");
                print('\x1B[32m$text\x1B[0m');
            }
            else{
                var text=("ONLY CREATOR CAN ADD A CHANNEL TO THIS CATEGORY");
                print('\x1B[31m$text\x1B[0m');
            }
        }
        else{
            var text="THIS CATEGORY DOES NOT EXISTS IN THIS SERVER ";
            print('\x1B[31m$text\x1B[0m');
        }
    }

    Future<void> add_role(String sname,String cat,String role,DbCollection? servers,DbCollection? categories,Map<String,dynamic> sess) async{
        bool match=await is_category(sname,cat,categories);
        if(match){
          Auth auth=Auth();
          String? creator=await auth.creator_Server(servers,sname);
          if(creator==sess["username"]){
               List<String> newrole=[sname,cat];
                await categories?.modernUpdate(
                where.eq('all',newrole),
                modify.push('roles',role)
                );
                var  text=("ROLE IS ADDED SUCCESSFULLY TO THIS CATEGORY!!!");
                print('\x1B[32m$text\x1B[0m');
          }
          else{
                var text=("ONLY CREATOR CAN ADD A ROLE TO THIS CATEGORY");
                print('\x1B[31m$text\x1B[0m');
          } 
        }
        else{
            var text="THIS CATEGORY DOES NOT EXISTS IN THIS SERVER ";
            print('\x1B[31m$text\x1B[0m');
        }
    }

    Future<void> show_cats(String sname,DbCollection? categories) async{
        int c=0;
            await categories?.find().forEach((v){
                if(v["sname"]==sname){
                    print(v["cat_name"]);
                    c+=1;
                }
            });
       if(c==0){
           var text="NO CATEGORY EXISTS IN THIS SERVER";
            print('\x1B[31m$text\x1B[0m');
       }
    }
}