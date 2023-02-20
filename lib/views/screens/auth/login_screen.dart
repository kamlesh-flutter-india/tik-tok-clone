import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/_core/string_const.dart';
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
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                height: 100.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringConst.tiktokClone,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.isRegisterJourney.value
                          ? StringConst.register
                          : StringConst.login,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Flexible(
                      child: Visibility(
                        visible: controller.isRegisterJourney.value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 2.h),
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage:
                                      controller.isPhotoSelected.value
                                          ? Image.file(
                                              controller.pickedFile.value,
                                              fit: BoxFit.cover,
                                              color: AppTheme.borderColor,
                                            ).image
                                          : const NetworkImage(
                                              StringConst.emptyImage),
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextInputField(
                                controller: _usernameController,
                                labelText: StringConst.userName,
                                icon: Icons.person,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextInputField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        labelText: StringConst.email,
                        icon: Icons.email,
                        validator: (_) {
                          final isValid =
                              controller.validateEmail(_emailController.text);
                          if (isValid || _emailController.text.isEmpty) {
                            return null;
                          } else {
                            return StringConst.emailError;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(
                        () => TextInputField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordController,
                          labelText: StringConst.password,
                          icon: Icons.lock,
                          isObscure: true,
                          validator: (_) {
                            if (!controller.isRegisterJourney.value) {
                              return null;
                            }

                            final isValid = controller
                                .validatePassword(_passwordController.text);
                            if (isValid || _passwordController.text.isEmpty) {
                              return null;
                            } else {
                              return StringConst.passwordError;
                            }
                          },
                        ),
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
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (controller.isRegisterJourney.value) {
                              await controller.registerUser(
                                username: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                // image: controller.pickedFile.value,
                              );
                            } else {
                              await controller.loginUser(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                          child: Center(
                            child: controller.isLoading.value
                                ? LoadingSpinner().fadingCircleSpinner
                                : Text(
                                    controller.isRegisterJourney.value
                                        ? StringConst.register
                                        : StringConst.login,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
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
                          StringConst.dontHaveAccount,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        InkWell(
                          onTap: () {
                            controller.changeJorney();
                            _emailController.clear();
                            _passwordController.clear();
                            _usernameController.clear();
                          },
                          child: Text(
                            !controller.isRegisterJourney.value
                                ? StringConst.register
                                : StringConst.login,
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
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
          ),
        );
      },
    );
  }
}
