class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? type;
  UserModel({this.uid, this.email, this.firstName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'type': type,
    };
  }
}