import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';

class Navbar extends StatelessWidget {

  final NavController navController = Get.find<NavController>();

  Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navController.currentIndex.value,
      onTap: (index) => navController.changeIndex(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Mis Eventos',
        ),
      ],
    );
  }
}