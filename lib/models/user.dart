import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String profilePic;
  final String email;
  final String uid;

  User({required this.name, required this.profilePic, required this.email, required this.uid});

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePic": profilePic,
        "email": email,
        "uid": uid,
      };

  static User fromJson(DocumentSnapshot snap) {
    final json = snap.data() as Map;
    return User(
      name: json["name"],
      profilePic: json["profilePic"],
      email: json["email"],
      uid: json['uid'],
    );
  }
}
