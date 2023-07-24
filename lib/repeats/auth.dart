import  "package:mongo_dart/mongo_dart.dart" show Db, DbConnection,DbCollection;
import "package:mongo_dart/mongo_dart.dart";
import "package:discord/repeats/db.dart";
import "package:crypt/crypt.dart";

class Auth{
    Auth();

    Future<bool> userLoggedIn(DbCollection? session)async{
        final curSession=await session?.findOne();
      //  print(curSession);
        bool check=(curSession!=null);
        return check;
    }
    Future<bool> userExists(String? username,DbCollection? users) async{
        bool match=false;
        await users?.find().forEach((v){
           // print(v);
           
            if(v['username']==username){
                match=true;
            }
        });
        return match;
    }
    Future<bool> serverExists(String? servername,DbCollection? servers) async{
        bool match=false;
        await servers?.find().forEach((v){
            if(v['sname']==servername){
                  match=true;
            }
        });
        return match;
    }
    Future<Map<String,dynamic>?> session() async{
       var baspi=BaseApi();
       DbCollection? sess=await baspi.coll("Sessions");
       if(sess!=null){
        return(sess.findOne());
       }
    }
    Future<bool> isCreator(String username,String server) async{
        BaseApi baspi=BaseApi();
        bool match =false;
       DbCollection? servers=await baspi.coll("Servers");
      
       await servers?.find().forEach((v){
       // print(v["sname"]);
        //print(server);
        if((v["sname"])==server){
           // print(username);
           // print(v["s_members"][0]["creator"]);
            if(v["s_members"][0]["member"]==(username)){
                match=true;
            }
            
        }
       });
       return match;
    }

    Future<Map<String,dynamic>?> get_cat(String sname,String? cat ,DbCollection? categories)async{
        Map<String,dynamic>? ans;
       await categories?.find().forEach((v){
        //print(v);
        
        if(v["s_name"]==sname && v["category"]==cat){
            ans =v;
        }
       });
       return ans;
    }

    Future<bool> channelExists(String sname,String cname,String? qname,DbCollection? chans)async{
        List<dynamic>? check;
        await chans?.find().forEach((v){
            if((v["c_type"]==qname)&& (v["ch_name"]==cname) && (v["s_name"]==sname)){
                check=v["all"];
              //  corr_pass=v["lock"];
            }
        });
        if(check!=null){
            return (true);
        }
        return false;
    }
    Future<bool> user_In_Server(DbCollection? servers,String sname,String uname) async{
       bool  match=false;
        await servers?.find().forEach((v){
            if(v["sname"]==sname){
                for(int i=0;i<v["members"].length;i++){
                     for(var key in v["members"][i].keys){
                        if(key==uname){
                            match=true;
                        }
                     }
                }
            }
        });

        return match;
    }
    Future<String> user_Role_In_Server(DbCollection? servers,String sname,String uname) async{
       String role="";
        await servers?.find().forEach((v){
            if(v["sname"]==sname){
                for(int i=0;i<v["members"].length;i++){
                     for(var key in v["members"][i].keys){
                        if(key==uname){
                            role=v["members"][i][key];
                        }
                     }
                }
            }
        });

        return role;
    }
     Future<String?> creator_Server(DbCollection? servers,String sname) async{
        String?  match;
        await servers?.find().forEach((v){
       //     print(v["sname"]);
       //     print(sname);
            if(v["sname"]==sname){
                match=v["creator"];
            }
        });

        return match;
    }

}
