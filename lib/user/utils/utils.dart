import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:siklero/model/bikeshops.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Utils { 

  Utils._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text, style: const TextStyle(color: Colors.white),), backgroundColor: Colors.red);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<void> openMap(
    double currLatitude,
    double currLongitude,
    double destLatitude, 
    double destLongitude) async{
      Uri googleMapUrl = Uri.parse("https://www.google.com/maps/dir/?api=1&origin=" + 
                                currLatitude.toString() +
                                ',' +
                                currLongitude.toString() +
                                '&destination=' +
                                destLatitude.toString() +
                                ',' +
                                destLongitude.toString() +
                                '&dir_action=navigate'
                                  );

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