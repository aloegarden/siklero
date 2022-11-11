import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocateBikeShopScreen extends StatefulWidget {
  const LocateBikeShopScreen({super.key});

  @override
  State<LocateBikeShopScreen> createState() => _LocateBikeShopScreenState();
}

class _LocateBikeShopScreenState extends State<LocateBikeShopScreen> {

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.581586664962659, 120.9761788),
    zoom: 14,
  );

  List<Marker> markers = <Marker>[];

  loadData () {
    goToCurrentLocation();
  }

  @override
  void initState () {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Locate Bike Shops', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        backgroundColor: const Color(0xffed8f5b),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToCurrentLocation,
        label: Text('Get current location'),
        icon: Icon(Icons.location_on_rounded),
      ),
    );
  }

  Future<void> goToCurrentLocation() async {
    getUserCurrentLocation().then((value) async {
      print(value.longitude.toString() + " " + value.latitude.toString());
      markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position: LatLng(value.latitude, value.longitude)
        )
      );
      CameraPosition cameraPosition = 
      CameraPosition(
        zoom: 14,
        target: LatLng(value.latitude, value.longitude,
      ));

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {
        
      });
    });
  }
  
  Future<Position> getUserCurrentLocation() async {
    
    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace) {
      print("Error: " + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  
}