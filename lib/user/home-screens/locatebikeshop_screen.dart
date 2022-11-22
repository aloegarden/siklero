import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siklero/model/bikeshops.dart';
import 'package:siklero/model/repair_guide/bikeshop.dart';
import 'package:siklero/user/utils/utils.dart';

class LocateBikeShopScreen extends StatefulWidget {
  const LocateBikeShopScreen({super.key});

  @override
  State<LocateBikeShopScreen> createState() => _LocateBikeShopScreenState();
}

class _LocateBikeShopScreenState extends State<LocateBikeShopScreen> {

  Completer<GoogleMapController> _controller = Completer();

  late BitmapDescriptor currentLocationIcon;
  late BitmapDescriptor bikeShopIcon;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.581586664962659, 120.9761788),
    zoom: 14,
  );

  List<Marker> markers = <Marker>[];
  List<BikeShops> _bikeShops = <BikeShops>[];

  loadData ()  async {
    markers = <Marker>[];
    goToCurrentLocation();
    //setMarkers();
  }

  @override
  void initState () {
    super.initState();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 
      'asset/img/user-pin.png')
      .then((value) => currentLocationIcon = value);

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 
      'asset/img/bike-shop-pin.png')
      .then((value) => bikeShopIcon = value);

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
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: loadData,
        label: Text('Get current location'),
        icon: Icon(Icons.location_on_rounded),
      ),
    );
  }

  Future<void> goToCurrentLocation() async {
    getUserCurrentLocation().then((value) async {
      //print(value.longitude.toString() + " " + value.latitude.toString());
      
      markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          icon: currentLocationIcon,
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

      setMarkers(value.latitude, value.longitude);

      setState(() {
        
      });
    });
  }
  
  Future<Position> getUserCurrentLocation() async {

    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Geolocator.requestPermission().then((value) {

      }).onError((error, stackTrace) {
        print("Error: " + error.toString());
      });

      return await Geolocator.getCurrentPosition();
    } else {

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }
    
  }

  Future<void> setMarkers(double latitude, double longitude) async {
    //markers = <Marker>[];
    getBikeShops(latitude, longitude).then((value) async {
      _bikeShops.addAll(value);

      //print('this is bikeshop after' + _bikeShops.toString());

      for (var bikeShop in _bikeShops) {
        //BikeShop details = await getBikeShop(bikeShop.placeId);
        //print(bikeShop);
        markers.add(
          Marker(
            markerId: MarkerId(bikeShop.placeId!),
            icon: bikeShopIcon,
            position: LatLng(bikeShop.latitude!, bikeShop.longitude!),
            onTap: () {
              showModalBottomSheet<dynamic>(
                context: context, 
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => buildSheet(bikeShop)
                );
            },
          )
        );
      }

      setState(() {
        
      });
    });

  }

  Future<List<BikeShops>> getBikeShops (double latitude, double longitude) async {
    //print("${markers.first.position.latitude} ${markers.first.position.longitude}");
    Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&keyword=bike+repair+shop&rankby=distance&key=AIzaSyBD7rR2WX5-WT7dN-IiyrOpfPfxK4CaIJ0");
    http.Response response = await http.get(uri);
    //print(response.statusCode);

    var bikeShops = <BikeShops>[];

    if (response.statusCode == 200) {
      var bikeShopsJson = json.decode(response.body);
      var jsonResults = bikeShopsJson["results"] as List;
      //print("pumaso sa 200");

      //print(jsonResults);
      
      return jsonResults.map((e) => BikeShops.fromJSON(e)).toList();
    }

    return bikeShops;
  }

  Future<BikeShop> getBikeShop (String? placeId) async {
    Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyBD7rR2WX5-WT7dN-IiyrOpfPfxK4CaIJ0");
    http.Response response = await http.get(uri);

    var bikeShop = BikeShop();

    if(response.statusCode == 200) {
      var bikeShopJson = json.decode(response.body);
      var jsonResults = bikeShopJson["result"];

      return BikeShop.fromJSON(jsonResults);
    }

    return bikeShop;
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child,),
  );
  
  Widget buildSheet(BikeShops bikeShop) {
    BikeShop? bikeShopDetails = new BikeShop();
    return FutureBuilder<BikeShop>(
      future: getBikeShop(bikeShop.placeId!),
      builder:(context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          bikeShopDetails = snapshot.data;

          return makeDismissible(
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              maxChildSize: 0.8,
              minChildSize: 0.4,

              builder: (_,controller) => Container(
                color: Colors.white,

                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,

                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("asset/img/bike-cover.jpg"),
                          fit: BoxFit.cover
                        )
                      ),
                    ),

                    Container(
                      child: ListTile(
                        title: Text(bikeShop.name!, overflow: TextOverflow.ellipsis,),
                        subtitle: Text(bikeShop.vicinity!, overflow: TextOverflow.ellipsis, maxLines: 2,),
                        trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        iconSize: 35,
                        onPressed:() => 
                        bikeShopDetails?.formattedPhoneNumber != null ? 
                        Utils.openCall(bikeShopDetails!.formattedPhoneNumber!) : 
                        showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: Text('No contact information found'),
                            );
                          }
                        ), 
        
                        icon: Icon(Icons.local_phone_outlined, color: Colors.green,),
                      ),
                      SizedBox(width: 10,),
                      IconButton(
                        iconSize: 35,
                        onPressed:() => Utils.openMap(bikeShop.latitude!, bikeShop.longitude!), 
                        icon: Icon(Icons.assistant_direction_rounded, color: Colors.deepOrangeAccent,),
                      ),
                    ],
                  ),
                      ),
                    )
                  ],
                ),
              )
            )
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
      );
  }

  
}