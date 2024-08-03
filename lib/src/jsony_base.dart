import 'dart:convert';

import 'package:jsony/jsony.dart';






class JsonyVar{

  late final String jsonyVarName;
  bool _match = true;
  bool get isMatched{ return _match; }
  JsonyVar(this.jsonyVarName);

}



class Jsony extends JsonyVar{

  List<dynamic> _variables = [];


  Jsony(super.jsonyVarName);


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
    return {jsonyVarName: result};
  }


  void updateElements(dynamic root){
    Map<String, dynamic> r = root[jsonyVarName];
    _variables.forEach((element) {
      bool exist = r.containsKey(element.jsonyVarName);
      try{
        if( !exist || (exist && root[jsonyVarName][element.jsonyVarName] != null) ) {
          element.updateElements(root[jsonyVarName]);
          if(!exist){ throw("Variable not found "); }
        }
        !element.isMatched ?_match=false :null;
      }
      catch(e){
        _match = false;
        print("${e.toString()} at \"$jsonyVarName\":{\"${element.jsonyVarName}\": ?}");
      }
    });

  }


  void fromJson(String jsonString){
    const JsonDecoder decoder = JsonDecoder();
    final Map<String,  dynamic> jsonObj = decoder.convert(jsonString);
    updateElements(jsonObj);
  }
}




class JsonyBool extends JsonyVar{

  late bool value;

  JsonyBool(super.jsonyVarName, this.value);
  bool call() => value;
  String get string{  return '"$jsonyVarName":$value';  }
  Map<String, bool> get obj{ return {jsonyVarName:value}; }
  void updateElements(dynamic v){
    _match=true;
    v[jsonyVarName]!=null
        ?value = bool.parse(v[jsonyVarName].toString())
        :_match=false;
  }
}




class JsonyString extends JsonyVar{

  late String value;

  JsonyString(super.jsonyVarName, [String? value]) : value = value??"";
  String call() => value;
  String get string{  return '"$jsonyVarName":"$value"';  }
  Map<String, String> get obj{ return {jsonyVarName:value}; }
  void updateElements(dynamic v){
    _match=true;
    v[jsonyVarName]!=null
      ?value = v[jsonyVarName].toString()
      :_match=false;
  }
}




class JsonyInt extends JsonyVar{

  late int value;

  JsonyInt(super.jsonyVarName, this.value);
  int call() => value;
  String get string{  return '"$jsonyVarName":$value';  }
  Map<String, int> get obj{ return {jsonyVarName:value}; }
  void updateElements(dynamic v){
    _match=true;
    v[jsonyVarName]!=null
      ?value = int.parse(v[jsonyVarName].toString())
      :_match=false;
  }
}




class JsonyListString extends JsonyVar{

  late List<String> value;

  JsonyListString(super.jsonyVarName, [List<String>? value]): value = value??[];
  List<String> call() => value;
  Map<String,List<String>> get obj{ return{jsonyVarName: value}; }
  void updateElements(dynamic v){
    _match=true;
    v[jsonyVarName]!=null
      ?value = List<String>.from(v[jsonyVarName] as List)
      :_match=false;
  }
}




class JsonyListDynamic extends JsonyVar{

  late List<dynamic> value;

  JsonyListDynamic(super.jsonyVarName, [List<dynamic>? value]): value = value??[];
  List<dynamic> call() => value;
  Map<String,List<dynamic>> get obj{ return{jsonyVarName: value}; }
  void updateElements(dynamic v){
    _match=true;
    v[jsonyVarName]!=null
      ?value = List<dynamic>.from(v[jsonyVarName] as List)
      :_match=false;
  }
}




class JsonyListListString extends JsonyVar{

  late List<List<String>> value;

  JsonyListListString(super.jsonyVarName, [List<List<String>>? value]): value = value??[];
  List<List<String>> call() => value;
  Map<String, List<List<String>>> get obj{ return{jsonyVarName: value}; }
  void updateElements(dynamic v){
    _match=true;
    if( v[jsonyVarName]!=null ) {
      value = [];
      List<dynamic> t = List<dynamic>.from(v[jsonyVarName] as List);
      t.forEach((element) {
        value.add(List<String>.from(element as List));
      });
    }
    else{ _match=false; }
  }
}




class JsonyListJsony extends JsonyVar{

  late List<Jsony> elements = [];
  // constructor wrapper for element objects
  late Function constructor;

  /// [jsonyVarName] Object name
  /// [constructor] Wrapper function that returns array element
  /// [elements] Array objects
  JsonyListJsony(super.jsonyVarName, Jsony this.constructor(int index), [List<Jsony>? elements]): elements = elements??[];
  List<Jsony> call() => elements;
  Map<String,List<dynamic>> get obj{
    List<dynamic> result = [];
    elements.forEach((element) {
      result.add(element.obj);
    });
    return {jsonyVarName: result};
  }
  void updateElements(dynamic v){
    try{
      List<dynamic> _elements = v[jsonyVarName];
      _elements.forEach((e) {
        // from json data
        Map<String, dynamic> element = Map<String, dynamic>.from(e);
        // create object
        Jsony newElement = constructor(_elements.indexOf(e));
        // mix newElement key and data values into new variable
        Map<String, dynamic> namedElement = {newElement.jsonyVarName: element.values.first};
        // update object
        newElement.updateElements(namedElement);
        elements.add(newElement);
        !elements.last.isMatched ?_match=false :null;
      });
    }
    catch(e){
      _match = false;
      print("${e.toString()} at \"$jsonyVarName\"}.");
    }
  }
}
