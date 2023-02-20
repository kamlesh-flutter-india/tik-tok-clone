import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktik_clone/constant.dart';
import 'package:tiktik_clone/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  final authController = Get.find<AuthController>();

  
  // ignore: prefer_final_fields
  var _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos =
        await firebaseStore.collection('videos').where('uid', isEqualTo: _uid.value).get();

    final videos = myVideos.docs.length;
    for (int i = 0; i < videos; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc = await firebaseStore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePic'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc =
        await firebaseStore.collection('users').doc(_uid.value).collection('followers').get();
    var followingDoc =
        await firebaseStore.collection('users').doc(_uid.value).collection('following').get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firebaseStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.value?.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await firebaseStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.value?.uid)
        .get();

    if (!doc.exists) {
      await firebaseStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.value?.uid)
          .set({});
      await firebaseStore
          .collection('users')
          .doc(authController.user.value?.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firebaseStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.value?.uid)
          .delete();
      await firebaseStore
          .collection('users')
          .doc(authController.user.value?.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
