import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentStoreModel{
  String? _documentName;
  String? _documentUrl;

  // Constructor For empty initialization
  DocumentStoreModel.initializeWithEmptyValues() : _documentName='', _documentUrl='empty';


  // Getters
  String get documentName => _documentName!;
  String get documentUrl => _documentUrl!;

  // Setters
  set documentName(String newValue)=> _documentName = newValue;
  set documentUrl(String newValue)=> _documentUrl = newValue;


  // Convert to Json
  Map<String,dynamic> toJson(){
    Map<String,dynamic> mapObject = {};
    mapObject['documentName'] = _documentName!;
    mapObject['documentUrl'] = _documentUrl!;
    
    return mapObject;
  }


  // From Snapshot
  DocumentStoreModel.fromSnapshot(DocumentSnapshot doc){
    Map<String,dynamic> mapObject = doc.data() as Map<String,dynamic>;
    
    _documentName = mapObject['documentName'];
    _documentUrl = mapObject['documentUrl'];
  }

}