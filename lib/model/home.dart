import 'package:flutter/material.dart';
import 'package:siklero/user/locatebikeshop_screen.dart';
import 'package:siklero/user/repair-guide_screen.dart';
import 'package:siklero/user/sosdetails_screen.dart';
import 'package:siklero/user/sosrespond_screen.dart';
import 'package:siklero/user/hotline_screen.dart';
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

List<Home> homeitems = [
  Home(
    id: 1,
    text: "Locate Bike Shop",
    icon: Icon(Icons.directions_bike_rounded, color: Colors.white, size: 75,),
    screen: LocateBikeShopScreen()
  ),
  Home(
    id: 2, 
    text: "Send SOS", 
    icon: Icon(Icons.sos_rounded, color: Colors.white, size: 75,),
    screen: SOSDetailsScreen(userInfo: null,)
  ),
  Home(
    id: 3, 
    text: "SOS Respond", 
    icon: Icon(Icons.emergency_share_rounded, color: Colors.white, size: 75,),
    screen: SOSRespondScreen()
  ),
  Home(
    id: 4, 
    text: "Hotlines", 
    icon: Icon(Icons.menu_book_rounded, color: Colors.white, size: 75,),
    screen: HotlineScreen()
  ),
  Home(
    id: 5, 
    text: "Repair Guide", 
    icon: Icon(Icons.map_outlined, color: Colors.white, size: 75,),
    screen: RepairGuideScreen()
  )
];