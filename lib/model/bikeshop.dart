import 'package:cloud_firestore/cloud_firestore.dart';

class BikeShop {
  String businessStatus;
  GeoPoint geometry;
  String name;
  String placeId;
  String vicinity;

  BikeShop({
    required this.businessStatus,
    required this.geometry,
    required this.name,
    required this.placeId,
    required this.vicinity
  });
}