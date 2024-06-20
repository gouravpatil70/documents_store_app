import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ViewDocument extends StatefulWidget {
  const ViewDocument({super.key});

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Document List'),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,bottom: 7.0),
              child: Card(
                elevation: 2.5,
                shadowColor: Colors.black,
                child: ListTile(
                  tileColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: const Text(
                    'Document Name',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.document_scanner_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}