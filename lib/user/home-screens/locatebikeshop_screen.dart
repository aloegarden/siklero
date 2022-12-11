import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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

  static const _kGoogleApiKey = "AIzaSyBD7rR2WX5-WT7dN-IiyrOpfPfxK4CaIJ0";

  late BitmapDescriptor currentLocationIcon;
  late BitmapDescriptor bikeShopIcon;
  late LatLng currentLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
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
      const ImageConfiguration(), 
      'asset/img/user-pin.png')
      .then((value) => currentLocationIcon = value);

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      'asset/img/bike-shop-pin.png')
      .then((value) => bikeShopIcon = value);

    //loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Bike Shops', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        backgroundColor: const Color(0xffed8f5b),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xffe45f1e)
                ),

                onPressed: () async {
                  goToCurrentLocation();
                },

                child: const ListTile(
                  leading: Icon(Icons.my_location_rounded, color: Colors.white,),
                  title: Text("Use Current Location", style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xffe45f1e),

        onPressed: () async {
          setMarkers();
        },
        label: const Text('Locate Bike Shops'),
        icon: const Icon(Icons.location_on_rounded),
      ),
    );
  }

  Future<void> goToCurrentLocation() async {
    getUserCurrentLocation().then((value) async {
      //print(value.longitude.toString() + " " + value.latitude.toString());
      
      currentLocation = LatLng(value.latitude, value.longitude);
      markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
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

      //setMarkers(value.latitude, value.longitude);

      setState(() {
        
      });
    });
  }
  
  Future<Position> getUserCurrentLocation() async {

    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Geolocator.requestPermission().then((value) {

      }).onError((error, stackTrace) {
        print("Error: $error");
      });

      return await Geolocator.getCurrentPosition();
    } else {

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }
    
  }

  Future<void> setMarkers() async {
    
    if (markers.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return const AlertDialog(
            content: Text('Location not yet set'),
          );
        }
      );
    } else {
      var locationMarker = markers.first;
      getBikeShops(locationMarker.position.latitude, locationMarker.position.longitude).then((value) async {
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

  }

  Future<List<BikeShops>> getBikeShops (double latitude, double longitude) async {
    //print("${markers.first.position.latitude} ${markers.first.position.longitude}");
    Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&keyword=bike+repair+shop&rankby=distance&key=$_kGoogleApiKey");
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
    Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_kGoogleApiKey");
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
    BikeShop? bikeShopDetails = BikeShop();
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

                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("asset/img/bike-cover.jpg"),
                          fit: BoxFit.cover
                        )
                      ),
                    ),

                    ListTile(
                      title: Text(bikeShop.name!, overflow: TextOverflow.ellipsis,),
                      subtitle: Text(bikeShop.vicinity!, overflow: TextOverflow.ellipsis, maxLines: 2,),
                      trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    IconButton(
                      iconSize: 35,
                      onPressed:() async { 
                      bikeShopDetails = await getBikeShop(bikeShop.placeId);

                      bikeShopDetails?.formattedPhoneNumber != null ? 
                      Utils.openCall(bikeShopDetails!.formattedPhoneNumber!) : 
                      showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return const AlertDialog(
                            content: Text('No contact information found'),
                          );
                        }
                      );
                      },
                      icon: const Icon(Icons.local_phone_outlined, color: Colors.green,),
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      iconSize: 35,
                      onPressed:() => Utils.openMap(currentLocation.latitude, currentLocation.longitude, bikeShop.latitude!, bikeShop.longitude!), 
                      icon: const Icon(Icons.assistant_direction_rounded, color: Colors.deepOrangeAccent,),
                    ),
                    ],
                    ),
                    ),
                    
                  ],
                ),
              )
            )
          );
  }

  
}