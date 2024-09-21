
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/ui/Widgets/Property/ProjectPropertyDetail.dart';

class SinglePropertyListWidget extends StatefulWidget {
  final property_id;
  const SinglePropertyListWidget({super.key,required this.property_id});

  @override
  State<SinglePropertyListWidget> createState() => _SinglePropertyListWidgetState();
}

class _SinglePropertyListWidgetState extends State<SinglePropertyListWidget> {
  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<MyProvider>(context);
    Widget propertyContent = Container();
    List<Map<String, dynamic>> propertyListDemo = [];
    var url = Uri.parse(ApiLinks.fetchSinglePropertyById);
    var data = {"p_id":widget.property_id};
    //print('proeprty id is the ${widget.property_id}');
    return PopScope(
      onPopInvoked: (didPop) {
        
      },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('property details'),
          ),
      body: const ProjectPropertyDetail()
    )
    );
  }
}
