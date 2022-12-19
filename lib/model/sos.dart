import 'package:cloud_firestore/cloud_firestore.dart';

class SOSCall {
  late String? documentID;
  late String? callerID;
  late String? respondantID;
  late String? details;
  late String? locationAddress;
  late String? city;
  late String? imageUrl;
  late bool? isActive;
  late bool? isCompleted;
  late GeoPoint? coordinates;
  late GeoPoint? helperCoordinates;
  late Timestamp? createdAt;

  SOSCall({
      this.documentID,
      this.callerID,
      this.respondantID,
      this.details,
      this.locationAddress,
      this.city,
      this.imageUrl,
      this.isActive,
      this.isCompleted,
      this.coordinates,
      this.helperCoordinates,
      this.createdAt
    });

  Map<String, dynamic> toJSON () => {
      'document_id' : documentID,
      'caller_id': callerID,
      'respondant_id': respondantID,
      'sos_details': details,
      'location_address': locationAddress,
      'city': city,
      'image_url' : imageUrl,
      'is_active': isActive,
      'is_completed': isCompleted,
      'coordinates': coordinates,
      'helper_coordinates': helperCoordinates,
      'created_at' : createdAt
  };

  static SOSCall fromJSON(Map<String, dynamic> json) => SOSCall(
      documentID: json['document_id'],
      callerID: json['caller_id'],
      respondantID: json['respondant_id'],
      details: json['sos_details'],
      locationAddress: json['location_address'],
      city: json['city'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
      isCompleted: json['is_completed'],
      coordinates: json['coordinates'],
      helperCoordinates: json['helper_coordinates'],
      createdAt: json['created_at']
    );

}