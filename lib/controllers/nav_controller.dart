import 'package:get/get.dart';

class NavController extends GetxController {
  var currentIndex = 0.obs; // Observable state

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
