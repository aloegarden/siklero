import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SOSCall {
  late String? documentID;
  late String? callerID;
  late String? respondantID;
  late String? details;
  late String? locationAddress;
  late String? city;
  late bool? isActive;
  late bool? isApproved;
  late bool? isReviewed;
  late GeoPoint? coordinates;
  late Timestamp? createdAt;


  //late Map<String, double> coordinates;

  SOSCall({
      this.documentID,
      this.callerID,
      this.respondantID,
      this.details,
      this.locationAddress,
      this.city,
      this.isActive,
      this.isApproved,
      this.isReviewed,
      this.coordinates,
      this.createdAt
    });

  Map<String, dynamic> toJSON () => {
      'document_id' : documentID,
      'caller_id': callerID,
      'respondant_id': respondantID,
      'sos_details': details,
      'location_address': locationAddress,
      'city': city,
      'is_active': isActive,
      'is_approved': isApproved,
      'is_reviewed' : isReviewed,
      'coordinates': coordinates,
      'created_at' : createdAt
  };

  static SOSCall fromJSON(Map<String, dynamic> json) => SOSCall(
      documentID: json['document_id'],
      callerID: json['caller_id'],
      respondantID: json['respondant_id'],
      details: json['sos_details'],
      locationAddress: json['location_address'],
      city: json['city'],
      isActive: json['is_active'],
      isApproved: json['is_approved'],
      isReviewed: json['is_reviewed'],
      coordinates: json['coordinates'],
      createdAt: json['created_at']
    );

}