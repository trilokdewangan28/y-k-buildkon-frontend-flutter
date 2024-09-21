import 'package:get/get.dart';
import 'package:JAY_BUILDCON/controller/PropertyListController.dart';

Future<void> initializeController()async{
  Get.put(PropertyListController());
}