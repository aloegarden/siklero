class UserData {
    late String? userName;
    late String? fName;
    late String? lName;
    late String? address;
    late String? city;
    late String? contact;
    late String? role;

    UserData({
      this.userName,
      this.address,
      this.fName,
      this.lName,
      this.city,
      this.contact,
      this.role
    });

    Map<String, dynamic> toJson () => {
                'address': address,
                'contact': contact,
                'first_name': fName,
                'last_name': lName,
                'city': city,
                'username': userName,
                'role': role
    };

    static UserData fromJSON(Map<String, dynamic> json) => UserData(
        address: json['address'],
        contact: json['contact'],
        fName: json['first_name'],
        lName: json['last_name'],
        city: json['city'],
        userName: json['username'],
        role: json['role']
    );
}