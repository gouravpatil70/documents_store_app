
// Screens Package
import 'package:documents_store_app/Screens/modify_user_details_screen.dart';
import 'package:documents_store_app/Screens/show_document.dart';
import 'package:documents_store_app/Screens/upload_documents_screen.dart';
import 'package:documents_store_app/Screens/documents_list_screen.dart';

// Widget Packages
import 'package:documents_store_app/Widgets/custom_alert_dialog.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/drawer_card_widget.dart';

// Flutter default packages
import 'package:flutter/material.dart';
import 'dart:async';

// Permission Handler
import 'package:permission_handler/permission_handler.dart';

// Firebase Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Firebase Authentication Part
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  // Required Variables
  Map<String,dynamic>? _recentDocuments;

  // Firestore Package
  final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    _recentDocuments = {};
    checkAuthentication();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Welcome ${_user != null ? _user!.displayName : ''},'),
      drawer: Drawer(
        child: Column(
          children: [

            // Drawer element 1 : (Showing The Name & email Id Info)
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              accountName: Text('Gourav'), 
              accountEmail: Text('Email'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 210, 217, 224),
                child: Text('G'),
              ),
            ),

            // Drawer element 2 : (View Document)
            GestureDetector(
              child: DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'View Documents', cardIcon: Icons.file_copy_rounded),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return ViewDocument(user: _user!);
                  }
                ));
              },
            ),

  
            // Drawer element 3 : (Upload Document)
            GestureDetector(
              child: DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'Upload Documents', cardIcon: Icons.upload_file_outlined),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return UploadDocuments(user: _user!,);
                  }
                )
                );
              },
            ),

            // Drawer element 3 : (Modify Details)
            GestureDetector(
              child: DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'Modify Details', cardIcon: Icons.update),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return ModifyUserDetails(user: _user!);
                  })
                );
              },
            ),

            // Drawer element 4 : (Log Out)
            GestureDetector(
              child: DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'Log Out', cardIcon: Icons.logout),
              onTap: (){
                _auth.signOut();
              },
            ),
          ],
        ),
      ),

      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Text : Recently Opened Applications 
            const Text(
              'Recently opened Documents',
              style: TextStyle(
                fontSize: 19.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold
              ),
            ),

            // Divider
            const Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: 15.0),
              child: Divider(),
            ),

            // Recently Opened Applications
            Expanded(
              child: ListView.builder(
                itemCount: _recentDocuments!.isNotEmpty ? _recentDocuments!.length : 1,
                itemBuilder: (BuildContext context, int index){
                  return _recentDocuments!.isEmpty
                  ? Card(
                    elevation: 3.0,
                    child: Container(
                      padding: const EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 205, 201, 201),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: const Center(
                        child: Text(
                          'No any document opened',
                          style: TextStyle(
                            color: Color.fromARGB(255, 54, 54, 54),
                          ),
                        ),
                      ),
                    ),
                  )
                  : GestureDetector(
                      child: Card(
                        elevation: 3.0,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 92, 175, 242),
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 220.0,
                                  child: Text(
                                    _recentDocuments![(index+1).toString()],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                ),
                                const Icon(
                                  Icons.file_copy_sharp,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        _getDocumentDetails(id: _recentDocuments![(index+1).toString()]);
                      },
                    );
                }
              )
            )
          ],
        ),
      ),
    );
  }

  // Checking Authtication 
  checkAuthentication(){
    _auth.authStateChanges().listen((user) async { 
      
      if(user == null){
        if(mounted){
          Navigator.pushReplacementNamed(context, '/loginScreen');
        }
      }else{
        if(mounted){
          setState((){
            _user = user;
            // print(_user!.displayName);
            // print(_user);
          });
          Timer(const Duration(seconds: 2),(()async{
            await checkAndAskStoragePermission();
          }));
          _checkRecentlyOpenedDocuments();
        }
      }
    });
  }

  checkAndAskStoragePermission()async{
    Permission permission = Permission.manageExternalStorage;
    if(await permission.isDenied){
      if(await _showDialogBoxForPermission('This app needs the storage permission')){
        if(await permission.isGranted){
          return true;
        }else{
          PermissionStatus permissionAccessResult = await permission.request();
          if(permissionAccessResult.isGranted){
            return true;
          }else if(permissionAccessResult.isDenied){
            checkAndAskStoragePermission();
          }
        }
      }
    }
  }

  _showDialogBoxForPermission(String message){
    Future<dynamic> result = CustomAlertDialog.customAelrtDialogBox(context: context, message: message);
    return result;
  }


  _checkRecentlyOpenedDocuments()async{
    var result = _cloudFirestore.collection('userDetails').doc(_user!.email);
    Map<String,dynamic> mapObject = {};
    result.collection('recentOpenedDocuments').doc('documents').get().then((value){
      mapObject = value.data() as Map<String,dynamic>;
      // print(mapObject.runtimeType);
      // print(mapObject);
      setState(() {
        _recentDocuments = mapObject;
      });
    });
      
  }

  _getDocumentDetails({required String id})async{
    var result = await _cloudFirestore.collection('userDetails').doc(_user!.email).collection('documents').doc(id).get();
    _navigateToTheDocumentScreen(id: result.id, data: result.data());
  }

  _navigateToTheDocumentScreen({required String id,required Map<String,dynamic>? data}){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context){
        return ShowDocument(user: _user!, documentDetails: {id:data});
      }
    ));
  }
}