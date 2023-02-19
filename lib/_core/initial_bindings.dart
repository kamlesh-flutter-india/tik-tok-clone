
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class InitBindings extends Bindings {
  InitBindings() {
    dependencies();
  }

  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}
