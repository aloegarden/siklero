import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils { 

  Utils._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<void> openMap(
    double latitude, 
    double longitude) async{
      Uri googleMapUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

      if (await canLaunchUrl(googleMapUrl)) {
        await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
      }
  }

  static Future<void> openCall(
    String number
  ) async {
    Uri numberUrl = Uri.parse("tel:$number");

    if (await canLaunchUrl(numberUrl)) {
      await launchUrl(numberUrl, mode: LaunchMode.externalApplication);
    }
  }
}