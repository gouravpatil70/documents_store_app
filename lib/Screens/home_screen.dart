import 'package:documents_store_app/Screens/upload_documents_screen.dart';
import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/drawer_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Firebase Authentication Part
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
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
                Navigator.pushNamed(context, '/viewDocument');
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
                Navigator.pushNamed(context, '/modifyDetails');
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
                itemCount: 1,
                itemBuilder: (BuildContext context, int index){
                  return Card(
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
    _auth.authStateChanges().listen((user) { 
      
      if(user == null){
        if(mounted){
          Navigator.pushReplacementNamed(context, '/loginScreen');
        }
      }else{
        if(mounted){
          setState(() {
            _user = user;
            print(_user!.displayName);
            print(_user);
          });
        }
      }
    });
  }
}