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

### Just call the member for access.

```dart

void main() async{
  
  Config config = Config("myconfig");
  
  print(config.domain()); // example.com
  config.domain.value = "example.org";
}

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

### Can use Json types.

```dart

class Config extends Jsony{
  JsonyString domain = JsonyString("domain", "example.com");
  JsonyInt port = JsonyInt("port", 8080);
  JsonyStringList mirrors = JsonyStringList("mirrors", ["example2.com", "example3.com"]);
  JsonyBool debug = JsonyBool("debug", false);
  JsonyDynamicList max = JsonyDynamicList("max", ["MB", 2048]);

  Config(super.name){  jsonTypes([domain,port,mirrors,debug,max]);  }
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
