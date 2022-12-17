import 'package:flutter/material.dart';
import 'package:siklero/user/home-screens/locatebikeshop_screen.dart';
import 'package:siklero/user/home-screens/repair-guide_screen.dart';
import 'package:siklero/user/home-screens/sos-history_screen.dart';
import 'package:siklero/user/home-screens/sosdetails_screen.dart';
import 'package:siklero/user/home-screens/sosrespond_screen.dart';
import 'package:siklero/user/home-screens/hotline_screen.dart';
class Home {

  final int id;
  final String text;
  final Icon icon;
  final Widget screen;
  
  Home({
    required this.id,
    required this.text,
    required this.icon,
    required this.screen
  });
}

List<Home> homeitemsUser = [
  Home(
    id: 1,
    text: "Locate Bike Shop",
    icon: const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 75,),
    screen: const LocateBikeShopScreen()
  ),
  Home(
    id: 2, 
    text: "Send SOS", 
    icon: const Icon(Icons.sos_rounded, color: Colors.white, size: 75,),
    screen: const SOSDetailsScreen(userInfo: null,)
  ),
  Home(
    id: 3, 
    text: "SOS History", 
    icon: const Icon(Icons.contact_phone_outlined , color: Colors.white, size: 75,), 
    screen: const SOSHistoryScreen()
  ),
  Home(
    id: 4, 
    text: "Hotlines", 
    icon: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 75,),
    screen: const HotlineScreen()
  ),
  Home(
    id: 5, 
    text: "Repair Guide", 
    icon: const Icon(Icons.map_outlined, color: Colors.white, size: 75,),
    screen: const RepairGuideScreen()
  )
];

List<Home> homeitemsHelper = [
  Home(
    id: 1,
    text: "Locate Bike Shop",
    icon: const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 75,),
    screen: const LocateBikeShopScreen()
  ),
  Home(
    id: 2, 
    text: "SOS Respond", 
    icon: const Icon(Icons.announcement_rounded, color: Colors.white, size: 75,),
    screen: const SOSRespondScreen()
  ),
  Home(
    id: 3, 
    text: "SOS History", 
    icon: const Icon(Icons.contact_phone_outlined , color: Colors.white, size: 75,), 
    screen: const SOSHistoryScreen()
  ),
  Home(
    id: 4, 
    text: "Hotlines", 
    icon: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 75,),
    screen: const HotlineScreen()
  ),
  Home(
    id: 5, 
    text: "Repair Guide", 
    icon: const Icon(Icons.map_outlined, color: Colors.white, size: 75,),
    screen: const RepairGuideScreen()
  )
];