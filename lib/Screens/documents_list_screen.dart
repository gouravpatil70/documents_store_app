// Screens & Widgets Custom Packages
import 'package:documents_store_app/Screens/show_document.dart';
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

// Firebase Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewDocument extends StatefulWidget {
  final User user;
  const ViewDocument({super.key, required this.user});

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {


  // Firestore instance
  final FirebaseFirestore _cloudStorage = FirebaseFirestore.instance;

  // Firebase Storage Instance
  final Reference  _firebaseStorage = FirebaseStorage.instance.ref();

  // Map object for storing data.
  Map<String,dynamic>? _mapObject;
  bool? isLoading;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _mapObject = {};
    getDocumentsOfTheUser();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Document List'),
      body: isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            itemCount: _mapObject!.isNotEmpty ? _mapObject!.length : 1,
            itemBuilder: (BuildContext context, int index){
              return _mapObject!.isEmpty
                ? Center(
                  child: Card(
                    elevation: 3.0,
                    shadowColor: Colors.black,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('No Any Documents Uploaded !!'),
                    ),
                  )
                )
                
                : Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0,bottom: 7.0),
                  child: Card(
                    elevation: 2.5,
                    shadowColor: Colors.blue,
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: Text(
                            _mapObject![(_mapObject!.keys).toList().asMap()[index]]['documentName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        
                          // Leading Icon
                          leading: const Icon(
                            Icons.file_open,
                            color: Colors.grey,
                            size: 28.0,
                          ),
                        
                          // Trailing Icon
                          trailing: 
                          IconButton(
                            tooltip: 'Delete from Cloud',
                            onPressed: ()=>_deleteFileFromCloudStorage(id: ((_mapObject!.keys).toList())[index]),
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                              size: 30.0,
                            ),
                          ),
                        
                          onTap: ()=>_navigateToDocumentFile(mapObjectKey: (((_mapObject!.keys).toList())[index]), mapObjectValue: _mapObject![(((_mapObject!.keys).toList())[index])]),
                        ),
                      ],
                    ),
                  ),
                );
            }
          ),
        ),
    );
  }



  // Getting the data from the firestore.
  getDocumentsOfTheUser()async{
  // Getting the all documents from the `document` collection
    
    var documentCollection = _cloudStorage.collection('userDetails').doc(widget.user.email).collection('documents');
    await documentCollection.get().then((snapshot){
      for(var snapshotData in snapshot.docs){
        _mapObject![snapshotData.id] = snapshotData.data();
      }
      setState(() {
        isLoading = false;
        // print(_mapObject);
      });
    });
  }


  // Navigate to Document File
  _navigateToDocumentFile({required String mapObjectKey ,required Map<String,dynamic> mapObjectValue})async{
    Map<String,dynamic> mapObject = {};
    mapObject[mapObjectKey] = mapObjectValue;
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context){
        return ShowDocument(documentDetails: mapObject, user: widget.user,);
      })
    );
  }

  _deleteFileFromCloudStorage({required String id})async{
    try{

      // Deleting file from the firestore database 
      await _cloudStorage.collection('userDetails').doc(widget.user.email).collection('documents').doc(id).delete();
      
      // Also delete the file from the firebase storage (where the files are stored)
      await _firebaseStorage.child(id).delete();
      
      await getDocumentsOfTheUser();

      await _showDialogBox('File Deleted from Cloud Storage');

      // Not updating the UI part of the screen.

      // Calling the method again for uplading the _mapObject so that UI can update.
    }catch(e){
      _showDialogBox(e.toString());
    }
    // print(_mapObject);
  }


  // Showing an dialogBox
  _showDialogBox(String message){
    CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
  }
  
}