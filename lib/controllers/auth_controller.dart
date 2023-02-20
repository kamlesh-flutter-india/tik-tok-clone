import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktik_clone/constant.dart';
import 'package:tiktik_clone/models/user.dart' as model;
import 'package:tiktik_clone/views/screens/auth/login_screen.dart';
import 'package:tiktik_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  RxBool isRegisterJourney = false.obs;
  RxBool isPhotoSelected = false.obs;
  Rx<File> pickedFile = File("").obs;
  RxBool isLoading = false.obs;

  late Rx<User?> user;

  @override
  void onReady() {
    user = firebaseAuth.currentUser.obs;
    user.bindStream(firebaseAuth.authStateChanges());
    ever(user, _setInitialScreen);

    super.onReady();
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      pickedFile = File(pickedImage.path).obs;
      isPhotoSelected.value = true;
      update();
    }
  }

  void changeJorney() {
    FocusManager.instance.primaryFocus?.unfocus();
    isRegisterJourney.value = !isRegisterJourney.value;
    update();
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      if (username.isNotEmpty &&
          password.isNotEmpty &&
          email.isNotEmpty &&
          pickedFile.value.path.isNotEmpty) {
        isLoading.value = !isLoading.value;
        // creating a account
        final userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        /// uploading a photo to the store
        final path = await _uploadImageToStorage(pickedFile.value);

        model.User user = model.User(
          email: email,
          name: username,
          profilePic: path,
          uid: userCredential.user?.uid ?? "",
        );

        await firebaseStore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar(
            "Oops, Something went wrong!", "Please enter all details!");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Oops, Something went wrong!", e.toString());
    }
  }

  Future<String> _uploadImageToStorage(File image) async {
    final Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser?.uid ?? "");

    final taskSnapShot = await ref.putFile(image);

    return await taskSnapShot.ref.getDownloadURL();
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  bool validateEmail(String input) {
    const regex =
        r"""^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$""";
    if (!RegExp(regex).hasMatch(input)) {
      return false;
    }
    return true;
  }

  bool validatePassword(String input) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');

    if (!regex.hasMatch(input)) {
      return false;
    }
    return true;
  }
}
