import 'dart:ffi';

class BikeShop {
  String? bikeShopId;
  String? bikeShopName;
  String? bikeShopAddress;
  List<String>? bikeShopOpeningHours;
  bool? isOpen;


  late Map<String, double> coordinates;
}