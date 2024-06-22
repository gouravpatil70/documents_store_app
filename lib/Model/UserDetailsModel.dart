import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel{
  String? _userName;
  String? _userEmailId;
  String? _userPassword;

  // Constructor For empty initialization
  UserDetailsModel.initializeWithEmptyValues() : _userName='', _userEmailId='', _userPassword='';


  // Getters
  String get userName => _userName!;
  String get userEmailId => _userEmailId!;
  String get userPassword => _userPassword!;

  // Setters
  set userName(String newValue)=> _userName = newValue;
  set userEmailId(String newValue)=> _userEmailId = newValue;
  set userPassword(String newValue)=> _userPassword = newValue;


  // Convert to Json
  Map<String,dynamic> toJson(){
    Map<String,dynamic> mapObject = {};
    mapObject['userName'] = _userName!;
    mapObject['userEmailId'] = _userEmailId!;
    mapObject['userPassword'] = _userPassword!;
    
    return mapObject;
  }


  // From Snapshot
  UserDetailsModel.fromSnapshot(DocumentSnapshot doc){
    Map<String,dynamic> mapObject = doc.data() as Map<String,dynamic>;
    
    _userName = mapObject['userName'];
    _userEmailId = mapObject['userEmailId'];
    _userPassword = mapObject['userPassword'];
  }

}