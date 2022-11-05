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

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.582043528087183, 120.9763075458278),
    zoom: 14
  );

  loadData () {
    getCurrentPosition().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());

            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude));

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

            setState(() {
              
            });
          });
  }

  Future<Position> getCurrentPosition () async {

    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text('Locate Bike Shop', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
      ),

      body: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async {
          getCurrentPosition().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());

            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude));

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

            setState(() {
              
            });
          });
        },

      child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}