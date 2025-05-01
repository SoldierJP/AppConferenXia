import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import 'home_screen.dart';
import 'miseventos_screen.dart';
import '../widgets/navbar.dart';

class NavWrapper extends StatelessWidget {
  final NavController navController = Get.put(
    NavController(),
  ); // Inject controller

  final List<Widget> _screens = [HomeScreen(), MisEventosScreen()];

  NavWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _screens[navController.currentIndex.value],
      ), // Reactive UI
      bottomNavigationBar: Navbar(),
    );
  }
}
