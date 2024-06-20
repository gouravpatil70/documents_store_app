import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:documents_store_app/Widgets/drawer_card_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Welcome, '),
      drawer: Drawer(
        child: Column(
          children: [
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

            DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'View Documents', cardIcon: Icons.file_copy_rounded),

            DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'Upload Documents', cardIcon: Icons.upload_file_outlined),

            DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'Modify Details', cardIcon: Icons.update),

            DrawerCardChildren.customDrawerCardWidget(context: context, cardTitle: 'Log Out', cardIcon: Icons.logout),
            
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


}