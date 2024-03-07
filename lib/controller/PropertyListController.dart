import 'package:get/get.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:flutter/material.dart';
import 'package:real_state/models/PropertyListModel.dart';

class PropertyListController extends GetxController{
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  
  RxString appBarContent = 'Y&K BUILDCON'.obs;
  RxString secondBtmContent = 'Login'.obs;
  RxString userType = ''.obs;
  RxString token = ''.obs;
  
  var propertyList = <PropertyList>[].obs;
  
  //=================================ASSIGN THE PROPERTY LIST
  void assignPropertyList(List<dynamic> resultList)async{
    List<dynamic> property=resultList;
    propertyList.assignAll(property.map((data) =>  PropertyList.fromJson(data)).toList());
  }
}