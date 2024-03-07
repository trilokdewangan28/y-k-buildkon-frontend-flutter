import 'package:get/get.dart';
import 'package:real_state/controller/PropertyListController.dart';

Future<void> initializeController()async{
  await Get.put(PropertyListController());
}