import "dart:convert";
import "package:crypt/crypt.dart";
import "package:mongo_dart/mongo_dart.dart";
import "dart:io";
import "package:discord/repeats/auth.dart";
import "package:discord/mongo.dart";
import "package:uuid/uuid.dart";

class Server{
    String? sname;
    String? creator;
    List<dynamic>? members;
    List<dynamic>? channels;
    List<dynamic>? categories;
    List<dynamic>? roles;
    void setter(sname,creator,members,channels,categories){
        this.sname=sname;
        this.creator=creator;
        this.members=members;
        this.channels=channels;
        this.categories=categories;
    }
    Future< Map<String,dynamic>?> is_Server(String server,DbCollection? servers) async{
        Map<String,dynamic>? ser;
        await servers?.find().forEach((v){
            if(v["sname"]==server){
                ser=v;
            }
        });
        return ser;
    }

    Future<void> curr_Server(String server,DbCollection? servers) async{
        final ser_Data=await is_Server(server,servers);
        if(ser_Data!=null){
            sname=ser_Data["sname"];
            creator=ser_Data["creator"];
            members=ser_Data["members"];
            channels=ser_Data["channels"];
            categories=ser_Data["categories"];
        }
    } 

    Future<void> creates(String server,String creator,DbCollection? servers) async{
        var ser_obj={
            "sname":server,
            "creator":creator,
            "members":[{creator:"mod"},],
            "channels":[],
            "categories":[],
        };
        setter(server,creator,[{creator:"mod"},],[],[]);
        await servers?.insertOne(ser_obj);
    }
    bool is_member(String name,Map<String,dynamic> given){
        bool match=false;
        for(int i=0;i<given["members"].length;i++){
            for(var key in given["members"][i].keys){
                if(key==name){
                    match=true;
                }
            }
        }
        return match;

    }
    Future<void> joins(String sname,String uname,String role,DbCollection? servers,Map<String,dynamic> sess) async{
        Map<String,dynamic>? given =await is_Server(sname,servers);
        if(given!=null){
            bool exists=is_member(uname,given);
            if(!exists){
          //     Map<String,dynamic>? sess=await auth.session();
               if(sess["username"]==given["creator"]){
               await servers?.modernUpdate(
                where.eq('sname',sname),
                modify.push('members', {"$uname":role})
                );
                var  text2=("MEMBER IS ADDED SUCCESSFULLY TO THIS SERVER");
                print('\x1B[32m$text2\x1B[0m');
               }
               else{
                var  text2=("ONLY CREATOR CAN ADD USER TO A SERVER");
                print('\x1B[31m$text2\x1B[0mvar');
               }
            }
            else{
                var  text2=("ALREADY A USER EXISTS IN THIS SERVER WITH THIS NAME");
                print('\x1B[31m$text2\x1B[0mvar');
            }
        }
        else{
            var  text2=("THIS SERVER DOES NOT EXISTS!!!");
             print('\x1B[31m$text2\x1B[0mvar');
        }
    } 

    Future<void> show_mods(String sname,DbCollection? servers)async{
        Map<String,dynamic>? ser=await is_Server(sname,servers);
        if(ser!=null){
            int n=ser["members"].length;
            if(n==0){
              var  text2=("THIS SERVER DOES NOT HAVE MODERATORS!!!");
              print('\x1B[31m$text2\x1B[0mvar');
            }
            else{
            for(int i=0;i<n;i++){
                for(var key in ser["members"][i].keys){
                    if(ser["members"][i][key]=="mod"){
                        print(key);
                    }
                }
            }
            }
        }
        else{
            var  text2=("THIS SERVER DOES NOT EXISTS!!!");
            print('\x1B[31m$text2\x1B[0mvar');
        }
    }

}