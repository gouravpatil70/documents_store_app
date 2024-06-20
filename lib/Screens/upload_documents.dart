import 'package:documents_store_app/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(context: context, appTitle: 'Upload Document'),
      body: const Center(
        child: Card(
          elevation: 3.0,
          shadowColor: Colors.black,

        ),
      ),
    );
  }
}