class BikeShops {
  String? businessStatus;
  //GeoPoint? geoPoint;
  double? longitude;
  double? latitude;
  String? name;
  String? placeId;
  String? vicinity;

  BikeShops({
    this.businessStatus,
    //this.geoPoint,
    this.longitude,
    this.latitude,
    this.name,
    this.placeId,
    this.vicinity
  });

  static BikeShops fromJSON(Map<String, dynamic> json) => BikeShops(
    businessStatus: json['business_status'], 
    //geoPoint: json['location'],
    longitude: json['geometry']['location']['lng'],
    latitude: json['geometry']['location']['lat'], 
    name: json['name'], 
    placeId: json['place_id'], 
    vicinity: json['vicinity']);
}