

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageOperations{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadImgToStorage(
      String childName, Uint8List file) async {
    //!   Important Note!
    /*! In the following line, we have a ref() method which points to
    the File or Image in the Firebase Storage and the child method can
    be any folder which is present in the storage or doesn't exist. Since
    we have no file in here, so we will keep the ref() the empty and will
    create a new folder by .child() in which we can store our Images.*/
    Reference ref =
    await _storage.ref().child(childName).child(_auth.currentUser!.uid);

    /* In the following line, we used the putData() instead of putFile()
    because we are trying to pu an Uint8List file which is in the form
    of bytes. The UploadTask isn't a future but we can make it a future. With
    the UploadTask, we have the ability of controlling how our image will be
    stored in the Firebase Storage.*/
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot tSnapshot = await uploadTask;
    String downloadImageUrl = await tSnapshot.ref.getDownloadURL();
    return downloadImageUrl;
  }
}