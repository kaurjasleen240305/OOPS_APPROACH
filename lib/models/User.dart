import "dart:convert";
import "package:crypt/crypt.dart";
import "package:mongo_dart/mongo_dart.dart";
//import "package:mongo_dart/mongo_dart.dart" ;
import "dart:io";
import "package:discord/repeats/auth.dart";
import "package:discord/mongo.dart";
import "package:uuid/uuid.dart";

class User{
    String? user_id;
    String? username;
    String? password;
 //   List<dynamic>? sender;
    List<dynamic>? receiver;
    User();
    void setter(username,u_id,password){
        this.user_id=u_id;
        this.username=username;
        this.password=password;
    }
    Future<Map<String,dynamic>?> findUser(String username,DbCollection? users) async{
        Map<String,dynamic>? user;
       await users?.find().forEach((v){
            if(v["username"]==username){
                user=v;
            }
        });
        return user;
    }
    Future<void> register(String name,DbCollection? users) async{
        var text=("Enter password to register:-");
        print('\x1B[34m$text\x1B[0m');
        var pass= stdin.readLineSync().toString();
        var text2=("Confirm password to register:-");
        print('\x1B[34m$text2\x1B[0m');
        var cpass=stdin.readLineSync().toString();
        if(pass==cpass){
            pass=Crypt.sha256(pass, rounds: 1000).toString();
            Map<String,dynamic> store={
                "user_id":Uuid().v1().toString(),
                "username":name,
                "password":pass,
                "reciever":[],
            };
            await users?.insert(store);
            var text3="SUCCESSFULLY REGISTERED";
            print('\x1B[32m$text3\x1B[0m');
        }
        else{
            var text=("PASSWORD AND CONFIRM PASSWORD NOT MATCH");
            print('\x1B[31m$text\x1B[0m');
        }
    }
    Future<void> login(String name,DbCollection? users,DbCollection? sess)async{
        
        Map<String,dynamic>? user=await findUser(name,users);
        if(user!=null){
            var text=("ENTER YOUR PASSWORD TO LOGIN");
            print("\x1B[34m$text\x1B[0m");
            var pass=stdin.readLineSync().toString();
            if(Crypt(user["password"]).match(pass)){
                var sessobj={"username":name,"session_token":Uuid().v4(),"session_id":user["user_id"]};
                await sess?.insertOne(sessobj);
                var text3=("$name IS LOGGED IN");
               print('\x1B[32m$text3\x1B[0m');
            }
            else{
               var  text2=("PASSWORD DOES NOT MATCH!! PLS USE CORRECT PASSWORD");
                print('\x1B[31m$text2\x1B[0mvar');
            }
        }
        else{
            var text2=("THIS USER IS NOT REGISTERED!! PLEASE REGISTER");
            print('\x1B[31m$text2\x1B[0m');
        }
    }
    Future<void> logout(String name,DbCollection? users,DbCollection? sess) async{
        Auth auth=Auth();
        var in_session=await auth.session();
        if(in_session!=null){
        if(name==in_session["username"]){
            Map<String,dynamic>? user=await findUser(name,users);
            var text=("ENTER YOUR PASSWORD TO LOGOUT");
            print("\x1B[34m$text\x1B[0m");
            var pass=stdin.readLineSync().toString();
            if(user!=null){
            if(Crypt(user["password"]).match(pass)){
                await sess?.remove({'username':name});
                var text2=("LOGGED OUT SUCCESSFULLY");
                print('\x1B[32m$text2\x1B[0m');
            }
            else{
                var text2=("PASSWORD DOES NOT MATCH!! PLS USE CORRECT PASSWORD");
                print('\x1B[31m$text2\x1B[0mvar');
            }
            }
        }
        else{
            var text=("THIS USER IS NOT LOGGED IN PRESENTLY");
            print('\x1B[31m$text\x1B[0m');
        }
        }
    }

    Future<void> send_dm(String uname,String message,DbCollection? users,Map<String,dynamic> sess) async{
        Map<String,dynamic>? receiver=await findUser(uname,users);
   //     Map<String,dynamic>? sender=await findUser(sess["username"],users);
        String s=sess["username"];
        if(receiver!=null){
            await users?.modernUpdate(
                where.eq('username',uname),
                modify.push('reciever', {"$s":message})
                ); 
            print("MESSAGE SENT SUCCESSFULLY TO $uname");
        }
        else{
            var text=("THIS USER IS NOT REGISTERED");
            print('\x1B[31m$text\x1B[0m');
        }
    }
    Future<void> show_dm(String uname,DbCollection? users,Map<String,dynamic> sess) async{
         Map<String,dynamic>? use=await findUser(uname,users);
          Map<String,dynamic>? sess_user=await findUser(sess["username"],users);
         if(use!=null && sess_user!=null){
            int c=0;
            for(int i=0;i<sess_user["reciever"].length;i++){
                for(var key in sess_user["reciever"][i].keys){
                    if(key==uname){
                        var text=uname+":"+ " "+sess_user["reciever"][i][key];
                        print('\x1B[32m$text\x1B[0m');
                        c+=1;
                    }
                }
            }
            if(c==0){
                var text=("SORRY NO MESSAGES BY $uname");
                print('\x1B[31m$text\x1B[0m');
            }
         }
          else{
            var text=("THIS USER IS NOT REGISTERED");
            print('\x1B[31m$text\x1B[0m');
        }
    }
}