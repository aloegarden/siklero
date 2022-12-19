import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siklero/model/sos.dart';

class TrackHelperScreen extends StatefulWidget {
  final GeoPoint sourceLocation;
  final GeoPoint destinationLocation;
  final String documentID;
  const TrackHelperScreen({super.key, required this.sourceLocation, required this.destinationLocation, required this.documentID});

  @override
  State<TrackHelperScreen> createState() => _TrackHelperScreenState();
}

class _TrackHelperScreenState extends State<TrackHelperScreen> {
  static GoogleMapController? _controller;
  SOSCall sosCall = SOSCall();
  
  

  List<Marker> _markers = <Marker>[];

  late BitmapDescriptor currentLocationIcon;
  late BitmapDescriptor helperLocationIcon;

  @override
  void initState () {
    super.initState();

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/user-pin.png')
      .then((value) => currentLocationIcon = value);

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/helper-pin.png')
      .then((value) => helperLocationIcon = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Helper', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        backgroundColor: const Color(0xffed8f5b),
        centerTitle: true,
        //automaticallyImplyLeading: false,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sos_call').doc(widget.documentID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GeoPoint helperLocation = snapshot.data!.get('helper_coordinates');
            GeoPoint sosLocation = snapshot.data!.get('coordinates');

            _markers.clear();

            final helperLatLng = LatLng(helperLocation.latitude, helperLocation.longitude);
            final sosLatLng = LatLng(sosLocation.latitude, sosLocation.longitude);

            _markers.add(
              Marker(
                markerId: MarkerId("helperLocation"),
                icon: helperLocationIcon,
                position: helperLatLng
              )
            );

            _markers.add(
              Marker(
                markerId: MarkerId("sosLocation"),
                icon: currentLocationIcon,
                position: sosLatLng
              )
            );


            _controller?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: helperLatLng,
                zoom: 14,
              ),
            ));

            print(_markers.length);

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(helperLocation.latitude, helperLocation.longitude),
                zoom: 14
              ),
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            );
          }
          return Center(child:  CircularProgressIndicator(),);
        },
      ),
    );
  }
}