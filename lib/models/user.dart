import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String profilePhotoUrl;
  final String email;
  final String bio;
  final DateTime createdAt;

  const User({
    required this.username,
    required this.email,
    required this.uid,
    required this.bio,
    required this.profilePhotoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "username" : username,
    "email" : email,
    "uid": uid,
    "bio" : bio,
    "profilePhotoUrl" : profilePhotoUrl,
    "createdAt" : createdAt,
  };

  static User fromSnap(DocumentSnapshot dSnap){
    var snapShot = dSnap.data() as Map<String, dynamic>;
    return User(
      username: snapShot["username"],
      email: snapShot["email"],
      uid: snapShot["uid"],
      bio: snapShot["bio"],
      profilePhotoUrl: snapShot["profilePhotoUrl"],
      createdAt: snapShot["createdAt"],
    );
  }
}
