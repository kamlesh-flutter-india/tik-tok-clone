import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktik_clone/constant.dart';
import 'package:tiktik_clone/controllers/auth_controller.dart';

import '../models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;
  final authController = Get.find<AuthController>();

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firebaseStore.collection('videos').doc(_postId).collection('comments').snapshots().map(
        (QuerySnapshot query) {
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
  }

  Future<void> postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc =
            await firebaseStore.collection('users').doc(authController.user.value?.uid).get();
        var allDocs =
            await firebaseStore.collection('videos').doc(_postId).collection('comments').get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePic'],
          uid: authController.user.value?.uid ?? "",
          id: 'Comment $len',
        );
        await firebaseStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(
              comment.toJson(),
            );
        DocumentSnapshot doc = await firebaseStore.collection('videos').doc(_postId).get();
        await firebaseStore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = authController.user.value?.uid;
    DocumentSnapshot doc =
        await firebaseStore.collection('videos').doc(_postId).collection('comments').doc(id).get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firebaseStore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firebaseStore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
