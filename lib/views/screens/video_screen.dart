import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/controllers/auth_controller.dart';

import '../../controllers/video_controller.dart';
import '../widgets/circle_animation.dart';
import '../widgets/video_player_item.dart';
import 'comment_screen.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.username,
                                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    data.caption,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        data.songName,
                                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: 100.h / 5),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfile(
                                  data.profilePhoto,
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => videoController.likeVideo(data.id),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 40,
                                    color: data.likes.contains(authController.user.value?.uid)
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  data.likes.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () =>
                                      Get.to(() => CommentScreen(), arguments: {"id": data.id}),
                                  child: const Icon(
                                    Icons.comment,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  data.commentCount.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.reply,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  data.shareCount.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const SizedBox(height: 8),
                                CircleAnimation(
                                  child: buildMusicAlbum(data.profilePhoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(25)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image(
              image: NetworkImage(profilePhoto),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
