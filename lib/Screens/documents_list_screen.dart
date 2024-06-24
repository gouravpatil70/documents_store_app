import 'dart:io';

import 'package:documents_store_app/Screens/show_document.dart';
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

// Firebase Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';



class ViewDocument extends StatefulWidget {
  final User user;
  const ViewDocument({super.key, required this.user});

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {


  // Firebase Connectivity
  final FirebaseFirestore _cloudStorage = FirebaseFirestore.instance;

  // Map object for storing data.
  Map<String,dynamic>? _mapObject;
  bool? isLoading;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  // bool? isFileExist;
  // bool? _isFileAvailable;
  int? _bottomIndexForProgressBar;

  // Dio instance
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _mapObject = {};
    _bottomIndexForProgressBar = 0;
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
                :
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0,bottom: 7.0),
                  child: Card(
                    elevation: 2.5,
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: const Color.fromARGB(255, 230, 234, 237),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: Text(
                            _mapObject![(_mapObject!.keys).toList().asMap()[index]]['documentName'],
                            style: const TextStyle(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        
                          // Leading Icon
                          leading: IconButton(
                            onPressed: (){},
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                              size: 30.0,
                            ),
                          ),
                        
                          // Trailing Icon
                          trailing: IconButton(
                            onPressed: (){
                              downloadFile(url: _mapObject![(_mapObject!.keys).toList().asMap()[index]]['documentUrl'],fileName: (((_mapObject!.keys).toList())[index]));

                              setState(() {
                                _bottomIndexForProgressBar = index+1;
                              });
                            },
                            icon: const Icon(
                              Icons.file_download_outlined,
                              color: Color.fromARGB(255, 18, 216, 61),
                              size: 33.0,
                            ),
                          ),
                        
                          onTap: ()=>_navigateToDocumentFile(mapObjectKey: (((_mapObject!.keys).toList())[index]), mapObjectValue: _mapObject![(((_mapObject!.keys).toList())[index])]),
                        ),
                        _bottomIndexForProgressBar != index+1
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: LinearProgressIndicator(
                              backgroundColor: const Color.fromARGB(255, 230, 234, 237),
                              value: downloadProgress == 1.0 ? 0.0 : downloadProgress,
                              valueColor: const AlwaysStoppedAnimation(Colors.red),
                            ),
                          )                        
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
    documentCollection.get().then((snapshot){
      for(var snapshotData in snapshot.docs){
        _mapObject![snapshotData.id] = snapshotData.data();
      }
      setState(() {
        isLoading = false;
        print(_mapObject);
      });
    });
  }

  // Navigate to Document File
  _navigateToDocumentFile({required String mapObjectKey ,required Map<String,dynamic> mapObjectValue})async{
    Map<String,dynamic> mapObject = {};
    mapObject[mapObjectKey] = mapObjectValue;
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context){
        return ShowDocument(documentDetails: mapObject);
      })
    );
  }

  // Downloading the file from the storage
  downloadFile({required String url, required String fileName})async{
    setState((){
      isDownloading = true;
    });

    String result = await saveFile(fileUrl: url,fileName: fileName);
    
    _showDialogBox(result);

    setState((){
      isDownloading = false;
    });

  }

  // Saving file into directory
  Future<String> saveFile({required String fileUrl, required String fileName})async{
    Directory? directory;
    try{
      // Platform method came from dart:io.
      if(Platform.isAndroid){   
        // For Android
        if(await _requestpermission(Permission.manageExternalStorage)){
          directory = await getExternalStorageDirectory();

          // Creating the another folder inside the Android folder          
          directory = getDirectoryPath(directory);
          print(directory!.path);

        }else{
          return "Permission Not Granted";
        }

      }else{
        // For IoS
      }

      // Check whether the directory is created or not 
      if(!await directory!.exists()){
        await directory.create(recursive: true);
      }

      if(await directory.exists()){
        File saveFile = File('${directory.path}/$fileName');
        await dio.download(fileUrl, saveFile.path, onReceiveProgress: (downloaded, totalSize){
          setState(() {
            downloadProgress = downloaded/totalSize;
            if(downloadProgress == 1.0){
              _bottomIndexForProgressBar = 0;
            }
          });
        });

        return "File Downloaded Successfully";
      }
    }catch(e){
      return e.toString();
    }
    return "File Not Downloaded";
  }

  // Getting the directory path where we want to store the file
  Directory? getDirectoryPath(Directory? directory){

    String newPath = '';
    List<String> folders = directory!.path.split('/');
    for(int i=0;i<folders.length;i++){
      String folder = folders[i];
      if(folder != 'Android'){
        newPath += '$folder/';
      }else{
        break;
      }
    }

    // Now create a another directory or folder inside the Android
    newPath = '${newPath}Android/DocumentStoreApp';
    directory = Directory(newPath);
    // print(directory.path);
    return directory;
  }

  // Checking whether the permission is given by the user or not
  Future<bool> _requestpermission(Permission permission)async{
    if(await permission.isGranted){
      return true;
    }else{
      PermissionStatus result = await permission.request();   // permission.request() return the permission status
      if(result.isGranted){
        return true;
      }else{
        return false;
      }
    }
  }

  // Showing an dialogBox
  _showDialogBox(String message){
    CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
  }
  
}