import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../constant.dart';
import '../models/video.dart';

class UploadVideoController extends GetxController {
  RxBool isUploading = false.obs;

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    try {
      Reference ref = firebaseStorage.ref().child('videos').child(id);

      UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return "";
    }
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  Future<void> uploadVideo(String songName, String caption, String videoPath) async {
    try {
      isUploading.value = !isUploading.value;
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await firebaseStore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firebaseStore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      print("here ${userDoc.data()}");

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
        thumbnail: thumbnail,
      );

      await firebaseStore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      isUploading.value = false;
      Get.back();
    } catch (e) {
      isUploading.value = false;
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
