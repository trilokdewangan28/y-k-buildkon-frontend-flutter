

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Widgets/Property/ProjectPropertyDetail.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/Provider/MyProvider.dart';

class SinglePropertyListWidget extends StatefulWidget {
  final property_id;
  const SinglePropertyListWidget({Key? key,required this.property_id}) : super(key: key);

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
