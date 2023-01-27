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
    double latitude,
    double longitude,
    ) async{
      Uri googleMapUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

      if (await canLaunchUrl(googleMapUrl)) {
        await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
      }
  }

  static Future<void> openCall(
    String number
  ) async {
    Uri numberUrl = Uri.parse("tel:+63$number");

    if (await canLaunchUrl(numberUrl)) {
      await launchUrl(numberUrl, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openHotlineCall(
    String number
  ) async {
    Uri numberUrl = Uri.parse("tel:$number");

    if (await canLaunchUrl(numberUrl)) {
      await launchUrl(numberUrl, mode: LaunchMode.externalApplication);
    }
  }

  
}