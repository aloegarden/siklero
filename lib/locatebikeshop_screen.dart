import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocateBikeShopScreen extends StatefulWidget {
  const LocateBikeShopScreen({super.key});

  @override
  State<LocateBikeShopScreen> createState() => _LocateBikeShopScreenState();
}

class _LocateBikeShopScreenState extends State<LocateBikeShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locate Bike Shop'),
      ),
    );
  }
}