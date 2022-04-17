class RiderModel {
  late String uid;
  late String password;
  late String role;
  late String address;
  late String name;
  late String email;

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'password': this.password,
      'role': this.role,
      'address': this.address,
      'name': this.name,
      'email': this.email,
    };
  }

  RiderModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'] as String;
    password = map['password'] as String;
    role = map['role'] as String;
    address = map['address'] as String;
    name = map['name'] as String;
    email = map['email'] as String;
  }

  RiderModel({
    required this.uid,
    required this.password,
    required this.role,
    required this.address,
    required this.name,
    required this.email,
  });
}
