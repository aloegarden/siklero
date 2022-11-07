class UserData {
    late String? userName;
    late String? fName;
    late String? lName;
    late String? address;
    late String? contact;
    late bool? isAdmin;

    UserData({
      this.userName,
      this.address,
      this.fName,
      this.lName,
      this.contact,
      this.isAdmin
    });

    Map<String, dynamic> toJson () => {
                'address': address,
                'contact': contact,
                'first_name': fName,
                'last_name': lName,
                'username': userName,
                'is_admin': isAdmin
    };

    static UserData fromJSON(Map<String, dynamic> json) => UserData(
        address: json['address'],
        contact: json['contact'],
        fName: json['first_name'],
        lName: json['last_name'],
        userName: json['username'],
        isAdmin: json['is_admin']
    );
}