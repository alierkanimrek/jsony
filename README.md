## Export and import class members as json format for Dart

**Jsony** makes it easy to get an json object from your class members and restore values from json source. How?

- Extend your class to Jsony.
- Declare a class member as one of Jsony Types.
- Notify the members to Jsony in constructor.

Then can export or import all values as an json object in one line.

## Example

### Have a class contains some configuration values.

```dart
class Config extends Jsony{
  JsonyString domain = JsonyString("domain", "example.com");
  JsonyInt port = JsonyInt("port", 8080);

  Config(super.name){  
    jsonTypes([domain,port]);  
  }
}

```



### Now you can store values in a json file and restore them anytime with a one line operation.

```dart

void main() async{

  File fh = File("config.json");
  Config config = Config("myconfig");

  // Write to file.
  fh.writeAsString(config.toJson); 

  // Read from file and restore values
  config.fromJson(await fh.readAsString());
}

```
```json
{
  "myconfig": {
    "domain": "example.com",
    "port": 8080
  }
}
```



### Just call the member for access.

```dart
  print(config.domain()); // example.com
  config.domain.value = "example.org"; // change value
  fh.writeAsString(config.toJson); // write to file.
```



### You can declare Jsony objects as a member of other Jsony objects.

```dart

class Config extends Jsony{
  JsonyString domain = JsonyString("domain", "example.com");
  JsonyInt port = JsonyInt("port", 8080);
  DbConfig db = DbConfig("db");

  Config(super.name){  jsonTypes([domain,port,db]);  }
}


class DbConfig extends Jsony{
  JsonyString ip = JsonyString("ip", "127.0.0.1");
  JsonyString uname = JsonyString("uname", "admin");
  JsonyInt port = JsonyInt("port", 8001);

  DbConfig(super.name){  jsonTypes([ip,uname,port]);  }
}


void main() async{
  
  Config config = Config("myconfig");
  print(config.db.uname()); // admin
}

```
```json
{"myconfig": {
    "domain": "example.com",
    "port": 8080,
    "db": {
      "ip": "127.0.0.1",
      "uname": "admin",
      "port": 8001
    }
  }
}
```



### Can use Json types.

```dart

class Config extends Jsony{
  JsonyString domain = JsonyString("domain", "example.com");
  JsonyInt port = JsonyInt("port", 8080);
  JsonyListString mirrors = JsonyListString("mirrors", ["example2.com", "example3.com"]);
  JsonyBool debug = JsonyBool("debug", false);
  JsonyListDynamic max = JsonyListDynamic("max", ["MB", 2048]);

  Config(super.name){  jsonTypes([domain,port,mirrors,debug,max]);  }
}
```
```json
{"myconfig": {
    "domain": "example.com",
    "port": 8080,
    "mirrors": [
      "example2.com",
      "example3.com"
    ],
    "debug": false,
    "max": [
      "MB",
      2048
    ]
  }
}
```



### Check the source need updating

```dart
void main() async{

  File fh = File("config.json");
  Config config = Config("myconfig");

  // Import from file.
  config.fromJson(await fh.readAsString());

  if(!config.isMatched){
    // Some variables are not in the file, needs update 
    fh.writeAsString(config.toJson);
  }

}
```

### List of Jsony Objects

```dart
class Config extends Jsony {
  JsonyListJsony team = JsonyListJsony("team", (index) {
    // It's constructor of list members that runs for every json member by fromJson()
    // So Jsony doesn't know the runtime type of members
    return Developer(index.toString());
  });

  // You should create an helper for access as your class
  List<Developer> get devTeam {
    return List<Developer>.from(team());
  }

  Config(super.name) {
    jsonTypes([team]);
  }
} 

class Developer extends Jsony{
  JsonyString fullName = JsonyString("fullName");
  Developer(super.name){ jsonTypes([fullName]); }
}

void main() async {
  //some codes
  
  print(config.devTeam[0].fullName()); 
}
```
```json
{ "myconfig": {
    "team": [
      {
        "0": {
          "fullName": "Luke Skywalker"
        },
        "1": {
          "fullName": "Han Solo"
        },
        "2": {
          "fullName": "Yoda"
        }
      }
    ]
  }
}
```