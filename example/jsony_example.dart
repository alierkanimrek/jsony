import 'dart:io';

import 'package:jsony/jsony.dart';




class Config extends Jsony{
  JsonyString domain = JsonyString("domain", "example.com");
  JsonyInt port = JsonyInt("port", 8080);
  JsonyStringList mirrors = JsonyStringList("mirrors", ["example2.com", "example3.com"]);
  JsonyBool debug = JsonyBool("debug", false);
  JsonyDynamicList max = JsonyDynamicList("max", ["MB", 2048]);
  DbConfig db = DbConfig("db");

  Config(super.name){  jsonTypes([domain,port,mirrors,debug,max,db]);  }
}


class DbConfig extends Jsony{
  JsonyString ip = JsonyString("ip", "127.0.0.1");
  JsonyString uname = JsonyString("uname", "admin");
  JsonyInt port = JsonyInt("port", 8001);

  DbConfig(super.name){  jsonTypes([ip,uname,port]);  }
}



void main() async{
  File fh = File("config.json");

  // Create and write to file if not exist.
  Config config = Config("myconfig");
  if(!await fh.exists()) {
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