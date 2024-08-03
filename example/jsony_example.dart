import 'dart:io';

import 'package:jsony/jsony.dart';
import 'package:jsony/src/jsony_base.dart';




class Config extends Jsony{
  JsonyString domain = JsonyString("domain", "example.com");
  JsonyInt port = JsonyInt("port", 8080);
  JsonyListString mirrors = JsonyListString("mirrors", ["example2.com", "example3.com"]);
  JsonyBool debug = JsonyBool("debug", false);
  JsonyListDynamic max = JsonyListDynamic("max", ["MB", 2048]);
  DbConfig db = DbConfig("db");
  JsonyListListString lang = JsonyListListString("lang", [["en", "fr", "tr"], ["English", "Français", "Türkçe"]]);
  JsonyListJsony team = JsonyListJsony("team", (index){ return Developer(index.toString()); });

  List<Developer> get devTeam{ return List<Developer>.from(team()); }

  Config(super.name){  jsonTypes([domain,port,mirrors,debug,max,db, lang, team]);  }
}


class DbConfig extends Jsony{
  JsonyString ip = JsonyString("ip", "127.0.0.1");
  JsonyString uname = JsonyString("uname", "admin");
  JsonyInt port = JsonyInt("port", 8001);

  DbConfig(super.name){  jsonTypes([ip,uname,port]);  }
}


class Developer extends Jsony{
  JsonyString fullName = JsonyString("fullName");
  JsonyString email = JsonyString("email");
  JsonyString profession = JsonyString("profession");
  JsonyString picUrl = JsonyString("picUrl");
  JsonyString github = JsonyString("github");

  Developer(super.name){ jsonTypes([fullName,email,profession,picUrl,github]); }
}



void main() async{
  File fh = File("config.json");

  // Create and write to file if not exist.
  Config config = Config("myconfig");
  if(!await fh.exists()) {
    Developer member = Developer("0");
    member.fullName.value = "Luke Skywalker";
    member.email.value = "luke@force.uni";
    member.profession.value = "Team Leader";
    member.github.value = "forcebewithyou";
    member.picUrl.value = "lskywalker.jpg";
    config.team.elements.add(member);
    fh.writeAsString(config.toJson);
  }

  print(config.db.uname()); // admin
  config.db.uname.value = "host";

  // Read from file
  String jsonString = await fh.readAsString();

  // Simulate as if file has changed
  jsonString = jsonString.replaceAll("admin", "root");

  // Import from file.
  config.fromJson(jsonString);

  print(config.db.uname()); // root
  print(config.lang()[1][1]); // Français
  print(config.devTeam[0].fullName()); // Luke Skywalker


  if(!config.isMatched){
    // Some variables are not in the file, needs update
    // Remove port variable from config.json and run again example
    // You will get warning as <Variable not found  at "myconfig":{"port": ?}>
    // (Now uname is updated on file)
    fh.writeAsString(config.toJson);
  }

  // print(config.toJson); //see all
  // print(config.obj); //see dart object

}