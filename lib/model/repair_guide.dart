import 'package:flutter/material.dart';
import 'package:siklero/user/repair-guide-screens/avoiding-crashes_screen.dart';
import 'package:siklero/user/repair-guide-screens/first-aid_screen.dart';
import 'package:siklero/user/repair-guide-screens/preparation_screen.dart';
import 'package:siklero/user/repair-guide-screens/roadside-repair_screen.dart';
import 'package:siklero/user/repair-guide-screens/tools_screen.dart';

class RepairGuide {

  final int id;
  final String text;
  final Icon icon;
  final Widget screen;

  RepairGuide ({
    required this.id,
    required this.text,
    required this.icon,
    required this.screen
  });
}

List<RepairGuide> repairguideItems = [
  RepairGuide(
    id: 1, 
    text: 'Tools', 
    icon: const Icon(Icons.home_repair_service_rounded, color: Colors.white, size: 75,), 
    screen: const ToolsScreen()
  ),
  RepairGuide(
    id: 2, 
    text: 'Preparation', 
    icon: const Icon(Icons.assignment_rounded, color: Colors.white, size: 75,), 
    screen: const PreparationScreen()
  ),
  RepairGuide(
    id: 3, 
    text: 'Roadside Repair', 
    icon: const Icon(Icons.build_circle_rounded, color: Colors.white, size: 75,), 
    screen: const RoadsideRepairScreen()
  ),
  RepairGuide(
    id: 4, 
    text: 'Avoiding Crashes', 
    icon: const Icon(Icons.warning_rounded, color: Colors.white, size: 75,), 
    screen: const AvoidingCrashesScreen()
  ),
  RepairGuide(
    id: 5, 
    text: 'Basic First Aid', 
    icon: const Icon(Icons.medical_information_rounded, color: Colors.white, size: 75,), 
    screen: const FirstAidScreen()
  ),
];