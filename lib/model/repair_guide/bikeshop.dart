class BikeShop {
  String? formattedPhoneNumber;

  BikeShop({
    this.formattedPhoneNumber
  });

  static BikeShop fromJSON(Map<String, dynamic> json) => BikeShop(
    formattedPhoneNumber: json['formatted_phone_number']
  );
}