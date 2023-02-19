import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/upload_video_controller.dart';
import '../loader_dialog.dart';
import '../widgets/text_input_fields.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  late File videoFile;
  late String videoPath;

  UploadVideoController uploadVideoController = Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    videoFile = Get.arguments["videoFile"];
    videoPath = Get.arguments["videoPath"];
    setState(() {
      controller = VideoPlayerController.file(videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(
                width: 100.w,
                height: 100.h / 1.5,
                child: VideoPlayer(controller),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextInputField(
                        controller: _songController,
                        labelText: 'Song Name',
                        icon: Icons.music_note,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextInputField(
                        controller: _captionController,
                        labelText: 'Caption',
                        icon: Icons.closed_caption,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        width: 100.w,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await uploadVideoController.uploadVideo(
                                _songController.text, _captionController.text, videoPath);
                          },
                          child: uploadVideoController.isUploading.value
                              ? LoadingSpinner().fadingCircleSpinner
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Share!',
                                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
