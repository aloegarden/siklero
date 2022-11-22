import 'package:cloud_firestore/cloud_firestore.dart';
class BikeShop {
  String? businessStatus;
  //GeoPoint? geoPoint;
  double? longitude;
  double? latitude;
  String? name;
  String? placeId;
  String? vicinity;

  BikeShop({
    this.businessStatus,
    //this.geoPoint,
    this.longitude,
    this.latitude,
    this.name,
    this.placeId,
    this.vicinity
  });

  static BikeShop fromJSON(Map<String, dynamic> json) => BikeShop(
    businessStatus: json['business_status'], 
    //geoPoint: json['location'],
    longitude: json['geometry']['location']['lng'],
    latitude: json['geometry']['location']['lat'], 
    name: json['name'], 
    placeId: json['place_id'], 
    vicinity: json['vicinity']);
}