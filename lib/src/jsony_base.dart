import 'dart:convert';






class JsonyVar{

  late final String name;
  bool _match = true;
  bool get isMatched{ return _match; }
  JsonyVar(this.name);

}



class Jsony extends JsonyVar{

  List<dynamic> _variables = [];


  Jsony(super.name);


  Jsony call() => this;


  void jsonTypes(List<dynamic> state){ _variables = state; }


  String get toJson{
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(obj);
  }


  Map<String, Map<String, dynamic>> get obj{
    Map<String, dynamic> result = {};
    _variables.forEach((element) {
      result.addAll(element.obj);
    });
    return {name: result};
  }


  void update(dynamic root){
    Map<String, dynamic> r = root[name];
    _variables.forEach((element) {
      bool exist = r.containsKey(element.name);
      try{
        if( !exist || (exist && root[name][element.name] != null) ) {
          element.update(root[name]);
          if(!exist){ throw("Variable not found "); }
        }
        !element.isMatched ?_match=false :null;
      }
      catch(e){
        _match = false;
        print("${e.toString()} at \"$name\":{\"${element.name}\": ?}");
      }
    });

  }


  void fromJson(String jsonString){
    const JsonDecoder decoder = JsonDecoder();
    final Map<String,  dynamic> jsonObj = decoder.convert(jsonString);
    update(jsonObj);
  }
}




class JsonyBool extends JsonyVar{

  late bool value;

  JsonyBool(super.name, this.value);
  bool call() => value;
  String get string{  return '"$name":$value';  }
  Map<String, bool> get obj{ return {name:value}; }
  void update(dynamic v){
    _match=true;
    v[name]!=null
        ?value = bool.parse(v[name].toString())
        :_match=false;
  }
}




class JsonyString extends JsonyVar{

  late String value;

  JsonyString(super.name, this.value);
  String call() => value;
  String get string{  return '"$name":"$value"';  }
  Map<String, String> get obj{ return {name:value}; }
  void update(dynamic v){
    _match=true;
    v[name]!=null
      ?value = v[name].toString()
      :_match=false;
  }
}




class JsonyInt extends JsonyVar{

  late int value;

  JsonyInt(super.name, this.value);
  int call() => value;
  String get string{  return '"$name":$value';  }
  Map<String, int> get obj{ return {name:value}; }
  void update(dynamic v){
    _match=true;
    v[name]!=null
      ?value = int.parse(v[name].toString())
      :_match=false;
  }
}




class JsonyStringList extends JsonyVar{

  late List<String> value;

  JsonyStringList(super.name, this.value);
  List<String> call() => value;
  Map<String,List<String>> get obj{ return{name: value}; }
  void update(dynamic v){
    _match=true;
    v[name]!=null
      ?value = List<String>.from(v[name] as List)
      :_match=false;
  }
}




class JsonyDynamicList extends JsonyVar{

  late List<dynamic> value;

  JsonyDynamicList(super.name, this.value);
  List<dynamic> call() => value;
  Map<String,List<dynamic>> get obj{ return{name: value}; }
  void update(dynamic v){
    _match=true;
    v[name]!=null
      ?value = List<dynamic>.from(v[name] as List)
      :_match=false;
  }
}
