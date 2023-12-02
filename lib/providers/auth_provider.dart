import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todoa/firebase_operations/storage_operations.dart';
import 'package:todoa/models/user.dart' as model;
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageOperations storageOperations = StorageOperations();

  bool _isObscure = false;
  bool get isObscure => _isObscure;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String result = "Some error occurred.";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
      setLoading(true);
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        setLoading(false);
        result = 'success';
      } else {
        setLoading(false);
        result = "Please fill all the feilds.";
      }
    } catch (e) {
      setLoading(false);
      result = e.toString();
    }
    return result;

    // firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<model.User> getDetails() async {
    User currentUser = firebaseAuth.currentUser!;

    DocumentSnapshot docSnap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(docSnap);
  }

  Future<String> signUpUser({
    required String username,
    required String bio,
    required String email,
    required String password,
    required Uint8List file,
    required DateTime createdAt
  }) async {
    String result = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          createdAt != null ||
          file != null) {
        //Signing up the user
      setLoading(true);
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.email.toString());

        String profilePhotoUrl =
            await storageOperations.uploadImgToStorage("profilePictures", file);

        // Storing data of user to Firestore (Using UID)
        model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          bio: bio,
          profilePhotoUrl: profilePhotoUrl,
          createdAt: createdAt
        );
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson())
            .then((value) {
        setLoading(false);
          result = "success";
        }).onError((error, stackTrace) {
        setLoading(false);
          result = error.toString();
        });

        // Storing data of user to Firestore (Without Using UID)

        // await _firestore.collection("users").add({
        //   "username": username,
        //   "bio": bio,
        //   "uid": cred.user!.uid,
        //   "email": email,
        //   "followers": [],
        //   "following": [],
        //   "photoUrl": photoUrl,
        // });

        // result = "success";
        setLoading(false);
      } 
      // else if (file == null) {
      //   result = "Please pick an image!";
      // } 
      else {
        setLoading(false);
        result = "Please Fill all the Fields.";
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == "invalid-email") {
        result = 'The email is Badly Formatted.';
        return result;
      } else if (e.code == "weak_password") {
        result = 'Your password is less than 6 characters.';
        return result;
      } else if (e.code == "email-already-in-use") {
        result = 'Email is already used by another account.';
        return result;
      } else {
        result = e.toString();
      }
    } catch (error) {
      setLoading(false);
      result = error.toString();
      return result;
    }
    setLoading(false);
    return result;
  }

  Future<String> logOut(BuildContext context) async {
    String result = "Some Error Occurred.";
    await firebaseAuth.signOut().then((value) {
      result = "success";
    }).onError((error, stackTrace) {
      result = error.toString();
    });

    return result;
  }

  model.User? _user;
  // AuthProvider authProvider = AuthProvider();
  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    model.User? mUser = await getDetails();
    _user = mUser;
    notifyListeners();
  }
}
