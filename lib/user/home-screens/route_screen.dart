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
  final GeoPoint location;
  final String docId;
  const RouteScreen({super.key, required this.destination, required this.docId, required this.location});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  late StreamSubscription<LocationData> locationSubscription;

  

  late BitmapDescriptor destinationLocationIcon;
  late BitmapDescriptor currentLocationIcon;
  late BitmapDescriptor startingLocationIcon;

  static const _kGoogleApiKey = "AIzaSyBD7rR2WX5-WT7dN-IiyrOpfPfxK4CaIJ0";

  //List<Marker> _markers = <Marker>[];
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = Set<Polyline>();



  LocationData? currentLocation;

  static const LatLng test = LatLng(14.583777828416313, 121.11498237081021);

  @override
  void initState() {    
    initIcons();
    getPolyPoints();
    getCurrentLocation();
    

    super.initState();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    
    super.dispose();
  }

  void initIcons() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/user-pin.png')
      .then((value) => destinationLocationIcon = value);

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/helper-pin.png')
      .then((value) => startingLocationIcon = value);

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/current-location-pin.png')
      .then((value) => currentLocationIcon = value);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _kGoogleApiKey, 
      PointLatLng(widget.location.latitude, widget.location.latitude), 
      PointLatLng(widget.destination.latitude, widget.destination.longitude));

      if (result.points.isNotEmpty) {
        result.points.forEach(
          (PointLatLng point) => polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          ),
        );
        setState(() {

        });
      }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        backgroundColor: const Color(0xffed8f5b),
        centerTitle: true,
      ),

      body: currentLocation == null 
      ? const Center(child: Text("Loading"),)
      : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 18
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.orange,
            width: 7
          ),
        },
        markers: {
          Marker(
            markerId: MarkerId("source"),
            icon: currentLocationIcon,
            position: LatLng(widget.location.latitude, widget.location.longitude),
        ),
          Marker(
          markerId: MarkerId("destination"),
          icon: destinationLocationIcon,
          position: LatLng(widget.destination.latitude, widget.destination.longitude)
        ),
          Marker(
            markerId: MarkerId("currentLocation"),
            icon: currentLocationIcon,
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
          )
        },
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  void getCurrentLocation() async {
    print("pumasok sa getcurrentlocation");
    Location location = Location();

    location.changeSettings(interval: 5);

    location.getLocation().then((location) {
      currentLocation = location;
      print(currentLocation);

      setState(() {
        
      });
    });

    GoogleMapController googleMapController = await _controller.future;

    locationSubscription = location.onLocationChanged.listen((newLocation) { 
      currentLocation = newLocation;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newLocation.latitude!, newLocation.longitude!),
            zoom: 18
          )
        )
      );

      updateLocation(newLocation.latitude!, newLocation.longitude!);

      if (mounted) {
        setState(() {
          
        });
      }

    });

    
  }

  Future updateLocation(double latitude, double longitude) async {

    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(widget.docId);

    await docSOS.update({'helper_coordinates' : GeoPoint(latitude, longitude)});
  }
}