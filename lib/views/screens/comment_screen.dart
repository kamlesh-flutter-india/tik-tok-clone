import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/_core/string_const.dart';
import 'package:tiktik_clone/controllers/auth_controller.dart';

import 'package:timeago/timeago.dart' as tago;

import '../../controllers/comment_controller.dart';

// ignore: must_be_immutable
class CommentScreen extends StatelessWidget {
  CommentScreen({Key? key}) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());
  final authController = Get.find<AuthController>();
  final id = Get.arguments["id"];

  @override
  Widget build(BuildContext context) {
    commentController.updatePostId(id);
    return Scaffold(
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(comment.profilePhoto),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "${comment.username}  ",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              comment.comment,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              tago.format(
                                comment.datePublished.toDate(),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${comment.likes.length} likes',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () => commentController.likeComment(comment.id),
                          child: Icon(
                            Icons.favorite,
                            size: 25,
                            color: comment.likes.contains(authController.user.value?.uid)
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      );
                    });
              }),
            ),
            const Divider(),
            ListTile(
              title: TextFormField(
                controller: _commentController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              trailing: TextButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await commentController.postComment(_commentController.text);
                  _commentController.clear();
                },
                child: const Text(
                  StringConst.send,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
