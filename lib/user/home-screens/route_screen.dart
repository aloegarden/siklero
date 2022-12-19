import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class RouteScreen extends StatefulWidget {
  final GeoPoint destination;
  final String docId;
  const RouteScreen({super.key, required this.destination, required this.docId});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {

  Completer<GoogleMapController> _controller = Completer();

  late BitmapDescriptor currentLocationIcon;
  late BitmapDescriptor bikeShopIcon;

  static const _kGoogleApiKey = "AIzaSyBD7rR2WX5-WT7dN-IiyrOpfPfxK4CaIJ0";

  //List<Marker> _markers = <Marker>[];
  List<LatLng> polylineCoordinates = [];
  LocationData? current;

  @override
  void initState() {
    super.initState();
    
    initIcons();
    getCurrentLocation();
    getPolyPoints();
  }

  initIcons() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/user-pin.png')
      .then((value) => currentLocationIcon = value);

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/bike-shop-pin.png')
      .then((value) => bikeShopIcon = value);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _kGoogleApiKey, 
      PointLatLng(current!.latitude!, current!.longitude!), 
      PointLatLng(widget.destination.latitude, widget.destination.longitude));

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));

        setState(() {
          
        });
      }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Bike Shops', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        backgroundColor: const Color(0xffed8f5b),
        centerTitle: true,
      ),

      body: current == null 
      ? const Center(child: Text("Loading"),)
      : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(current!.latitude!, current!.longitude!),
          zoom: 14
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.orange,
            width: 7
          ),
        },
        markers: {
           Marker(
            markerId: MarkerId("destination"),
            icon: bikeShopIcon,
            position: LatLng(widget.destination.latitude, widget.destination.longitude)
          ),
          Marker(
            markerId: MarkerId("currentLocation"),
            icon: currentLocationIcon,
            position: LatLng(current!.latitude!, current!.longitude!)
          )
        },
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      current = location;
    });

    GoogleMapController _googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) { 
      current = newLocation;

      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newLocation.latitude!, newLocation.longitude!),
            zoom: 14
          )
        )
      );

      updateLocation(newLocation.latitude!, newLocation.longitude!);

      setState(() {
        
      });
    });
  }

  Future updateLocation(double latitude, double longitude) async {

    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(widget.docId);

    await docSOS.update({'helper_coordinates' : GeoPoint(latitude, longitude)});
  }
}