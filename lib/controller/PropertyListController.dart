import 'package:get/get.dart';
import 'package:JAY_BUILDCON/models/PropertyListModel.dart';

class PropertyListController extends GetxController{
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  
  RxString appBarContent = 'JAY BUILDCON'.obs;
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