import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/controllers/auth_controller.dart';
import 'package:tiktik_clone/views/loader_dialog.dart';

import '../../../_core/theme_config.dart';
import '../../widgets/text_input_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: Get.find<AuthController>(),
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tiktok Clone',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    controller.isRegisterJourney.value ? 'Register' : 'Login',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Visibility(
                    visible: controller.isRegisterJourney.value,
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: controller.isPhotoSelected.value
                                  ? Image.file(
                                      controller.pickedFile.value!,
                                      fit: BoxFit.cover,
                                      color: AppTheme.borderColor,
                                    ).image
                                  : const NetworkImage(
                                      'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                              backgroundColor: Colors.grey,
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  controller.pickImage();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextInputField(
                            controller: _usernameController,
                            labelText: 'Username',
                            icon: Icons.person,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextInputField(
                      controller: _emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextInputField(
                      controller: _passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      isObscure: true,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Obx(
                    () => Container(
                      width: 100.w - 32,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppTheme.buttonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (controller.isRegisterJourney.value) {
                            controller.registerUser(
                              username: _usernameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              image: controller.pickedFile.value,
                            );
                          } else {
                            controller.loginUser(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: Center(
                          child: controller.isLoading.value
                              ? LoadingSpinner().fadingCircleSpinner
                              : Text(
                                  controller.isRegisterJourney.value ? 'Register' : 'Login',
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(),
                      ),
                      InkWell(
                        onTap: controller.changeJorney,
                        child: Text(
                          !controller.isRegisterJourney.value ? 'Register' : 'Login',
                          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                color: Colors.blue,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
