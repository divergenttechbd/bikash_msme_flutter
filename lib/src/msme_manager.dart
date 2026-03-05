import 'package:flutter/material.dart';
import 'pages/pin_page.dart';
import 'pages/menu_page.dart';

class MSMEManager {
  static const String _correctPin = '4444';
  
  static void launchSDK(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PinPage(),
      ),
    );
  }
  
  static bool validatePin(String pin) {
    return pin == _correctPin;
  }
  
  static void navigateToMenu(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MenuPage(),
      ),
    );
  }
}
