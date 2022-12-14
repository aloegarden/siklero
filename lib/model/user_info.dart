class UserData {
    late String? userName;
    late String? fName;
    late String? lName;
    late String? address;
    late String? city;
    late String? contact;
    late String? emergencycontactName;
    late String? emergencycontactNumber;
    late String? role;

    UserData({
      this.userName,
      this.address,
      this.fName,
      this.lName,
      this.city,
      this.contact,
      this.emergencycontactName,
      this.emergencycontactNumber,
      this.role
    });

    Map<String, dynamic> toJson () => {
                'address': address,
                'contact': contact,
                'emergency_contact_name' : emergencycontactName,
                'emergency_contact_number' : emergencycontactNumber,
                'first_name': fName,
                'last_name': lName,
                'city': city,
                'username': userName,
                'role': role
    };

    static UserData fromJSON(Map<String, dynamic> json) => UserData(
        address: json['address'],
        contact: json['contact'],
        emergencycontactName: json['emergency_contact_name'],
        emergencycontactNumber: json['emergency_contact_number'],
        fName: json['first_name'],
        lName: json['last_name'],
        city: json['city'],
        userName: json['username'],
        role: json['role']
    );
}