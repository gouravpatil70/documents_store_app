// Imput & Output operations
import 'dart:io';

// Widgets custom package
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';


// Material Package
import 'package:flutter/material.dart';

// For opening the file
import 'package:open_file/open_file.dart';

// For getting the application directory path
import 'package:path_provider/path_provider.dart';

// File Downloader
import 'package:dio/dio.dart';

// For File Sharing 
import 'package:share_plus/share_plus.dart';

// Database Storage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowDocument extends StatefulWidget {
  final Map<String,dynamic> documentDetails;
  final User user;
  const ShowDocument({super.key, required this.user, required this.documentDetails});

  @override
  State<ShowDocument> createState() => _ShowDocumentState();
}

class _ShowDocumentState extends State<ShowDocument> {

  // Required Variables for displaying onto the UI
  String? fileName;
  String? fileUrl;
  String? fileTitle;
  IconData? displayIcon;
  int? numberOfDoc;

  // Dio instance
  final Dio dio = Dio();

  // For File Download Progress
  double? _fileDownloadedProgress;
  bool? _isFileExist;
  Directory? _localDirectory;

  // Firestore instance
  final FirebaseFirestore  _cloudFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fileName = ((widget.documentDetails).keys).toList()[0];
    fileUrl = widget.documentDetails[fileName]['documentUrl'];
    fileTitle = widget.documentDetails[fileName]['documentName'];
    checkExtention();
    _fileDownloadedProgress = 0.0;
    _isFileExist = false;
    numberOfDoc = 0;
    _checkFileExistOrNot(fileName: fileName!);
  }

  // For Checking the file extention based on that showing the Icon on the screen
  checkExtention(){
    String pattern = fileName!.split('.')[1];
    if(pattern == 'jpg' || pattern == 'png' || pattern == 'webp' || pattern == 'jpeg'){
      displayIcon = Icons.photo_size_select_actual_outlined;
    }else if(pattern == 'mp3'){
      displayIcon = Icons.music_video_rounded;
    }else if(pattern == 'docx' || pattern == 'txt' || pattern == 'pdf' || pattern == 'rtf'){
      displayIcon = Icons.edit_document;
    }else{
      displayIcon = Icons.dashboard_customize_outlined;
    }

  }


  @override
  Widget build(BuildContext context) {
    // print(widget.documentDetails);
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.documentDetails.keys.toList()[0]),
        centerTitle: true,
        elevation: 3.0,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 10.0),
        child: Column(
          children: [

            // Displaying the Icon
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(3.0),
              child: Card(
                surfaceTintColor: const Color.fromARGB(255, 0, 136, 255),
                elevation: 3.0,
                shadowColor: Colors.blue,
                
                child: Column(
                  children: [
                    Padding(
                      padding:  const EdgeInsets.only(top: 20.0),
                        child: Icon(
                          displayIcon,
                          size: 250.0,
                          color: Colors.grey,
                      ),
                    ),
              
                    // Displaying file name
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        fileName!,
                        style: const TextStyle(
                          fontSize:18.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            

            // Save the file
           _isFileExist == false
           ? GestureDetector(
                child: customListTile(message: 'Save', trailingIcon: Icons.file_download_outlined, iconColor: Colors.green,isProgressShow: true),

                onTap: ()=>_startDownloadingFile(fileUrl: fileUrl!,fileName: fileName!),
              )
            : const SizedBox(),

            _isFileExist != false 
            ? GestureDetector(
                child: customListTile(message: 'Open File', trailingIcon: Icons.file_present, iconColor: Colors.grey,isProgressShow: false),
                onTap: ()=>_openFileFromLocalStorage(),
              )
            : const SizedBox(),

            _isFileExist != false 
            ? GestureDetector(
                child: customListTile(message: 'Share File', trailingIcon: Icons.ios_share, iconColor: Colors.blue,isProgressShow: false),
                onTap: ()=> _shareFileWithOtherApplications(),
              )
            : const SizedBox(),

            _isFileExist != false 
            ? GestureDetector(
                child: customListTile(message: 'Delete from local', trailingIcon: Icons.delete_forever_outlined, iconColor: Colors.red,isProgressShow: false),
                onTap: ()=>_deleteFileFromLocalStorage(),
              )
            : const SizedBox(),
            
          ],
        ),
      ),
    );
  }

  // Custom UI Widget
  Container customListTile({required String message, required IconData trailingIcon, required MaterialColor iconColor,required bool isProgressShow}){
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      margin: const EdgeInsets.only(left: 35.0,right: 35.0),
      child: Card(
        elevation: 3.0,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              isProgressShow != true
              ? Icon(
                  trailingIcon,
                  size: 30.0,
                  color: iconColor,
                )
              : SizedBox(
                width: 35.0,
                height: 35.0,
                child: Stack(
                  children: [
                    Positioned(
                      child: Icon(
                        trailingIcon,
                        size: 30.0,
                        color: iconColor,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 2,
                      right: 4,
                      child: CircularProgressIndicator(
                        value: _fileDownloadedProgress != 1.0 ? _fileDownloadedProgress : 0.0,
                        valueColor: const AlwaysStoppedAnimation(Colors.red),
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  // Check File exist or not
  _checkFileExistOrNot({required String fileName})async{
    Directory? directory;
    try{
      directory = await getExternalStorageDirectory();
      directory = _gettingTheFileDirectoryForStorage(directory);
      if(await directory!.exists()){
        setState(() {
          _localDirectory = directory;
        });
      }else{
        setState(() {
          directory!.create(recursive: true);
          _localDirectory = directory;
        });
      }
      File file =  File('${directory.path}/$fileName');
      if(await file.exists()){
        setState(() {
          _isFileExist = true;
        });
      }else{
        setState(() {
          _isFileExist = false;
        });
      }

    }catch(e){
      _showErrorMessage(e.toString());
    }
  }

  // OpenFile
  _openFileFromLocalStorage()async{
    File file = File('${_localDirectory!.path}/$fileName');
    OpenFile.open(file.path);

    // then Store it into the database.
    var resultOfRecentDoc = _cloudFirestore.collection('userDetails').doc(widget.user.email).collection('recentOpenedDocuments');

    var resultOfUserDetails = _cloudFirestore.collection('userDetails').doc(widget.user.email);
    await resultOfRecentDoc.get().then((value)async{
      numberOfDoc = (value.docs).length;
      if(numberOfDoc! >= 5){

        // Getting the last updated document
        var dataSnapshot = await resultOfUserDetails.get();
        var resultOfData = dataSnapshot.data() as Map<String,dynamic>;
        int lastUpdatedDoc = int.parse(resultOfData['lastUpdatedDoc']);
        if(lastUpdatedDoc>=5){
          lastUpdatedDoc = 0;
        }
        resultOfRecentDoc.doc((lastUpdatedDoc+1).toString()).update({'docId':fileName!});
        lastUpdatedDoc += 1;

        // print(lastUpdatedDoc);

        // Updating the last updated document into user data
        resultOfUserDetails.update({'lastUpdatedDoc':(lastUpdatedDoc).toString()});
      }else{
        resultOfUserDetails.update({'lastUpdatedDoc':(numberOfDoc!+1).toString()});
        resultOfRecentDoc.doc((numberOfDoc!+1).toString()).set({'docId':fileName!});
      }
    });

  }

  _shareFileWithOtherApplications()async{
    File file = File('${_localDirectory!.path}/$fileName');
    List<XFile> filesList = [XFile(file.path)];
    Share.shareXFiles(filesList, text:"Check out this file !!");
  }

  // Delete File from local Storage
  _deleteFileFromLocalStorage()async{
    File file = File('${_localDirectory!.path}/$fileName');
    try{
      await file.delete(recursive: true);
      _showErrorMessage('File Deleted Successfully');

      _checkFileExistOrNot(fileName: fileName!);  // Checking file exist or not if not then show the download button
    }catch(e){
      _showErrorMessage(e.toString());
    }
    
  }


  // Downloading The file
  _startDownloadingFile({required String fileUrl, required String fileName})async{
    setState((){});

    String saveFileResult = await _saveFileToLocalStorage(fileUrl: fileUrl, fileName: fileName);

    _showErrorMessage(saveFileResult);

    _checkFileExistOrNot(fileName: fileName);   // Once downloaded the file then disable the save button.
    
    setState((){});
  }

  


  // Saving File to Local Storage from Firebase Url
  Future<String> _saveFileToLocalStorage({required String fileUrl, required String fileName})async{
    
    if(await _localDirectory!.exists()){
      File file = File('${_localDirectory!.path}/$fileName');
      await dio.download(fileUrl, file.path,onReceiveProgress: (fileDownloaded, totalSize){
        setState(() {
          _fileDownloadedProgress = fileDownloaded / totalSize;
        });
      });
      return "File Downloaded Successfully";
    }else{
      _localDirectory!.create(recursive: true);
    }
    return "File Not Downloaded";
  }

  // Getting the file directory where I want to store the file
  _gettingTheFileDirectoryForStorage(Directory? directory){
    String newFilePath = '';
    List<String> directoryPath = (directory!.path).split('/');
    for(int i=1;i<directoryPath.length; i++){
      String folderName = directoryPath[i];
      if(folderName != 'Android'){
        newFilePath += '$folderName/';
      }else{
        break;
      }
    }
    directory = Directory('$newFilePath/Android/DocumentStoreApp');
    return directory;
  }

  // Showing An error message
  _showErrorMessage(String message){
    CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
  }
}

