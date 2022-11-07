import 'package:cloud_firestore/cloud_firestore.dart';

class SOSCall {
  late String? userID;
  late String? details;
  late bool? isActive;
  late GeoPoint? coordinates;
  late Timestamp? createdAt;


  //late Map<String, double> coordinates;

  SOSCall({
      this.userID,
      this.details,
      this.isActive,
      this.coordinates,
      this.createdAt
    });

  Map<String, dynamic> toJSON () => {
          'user_id': userID,
          'sos_details': details,
          'is_active': isActive,
          'coordinates': coordinates,
          'created_at' : createdAt
  };

  static SOSCall fromJSON(Map<String, dynamic> json) => SOSCall(
      userID: json['user_id'],
      details: json['sos_details'],
      isActive: json['is_active'],
      coordinates: json['coordinates'],
      createdAt: json['created_at']
    );

}