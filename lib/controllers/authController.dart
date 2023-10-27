import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString token = "".obs;
  RxString userId = "".obs;
  Rx<Map<String, dynamic>> decodedToken = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> unverifiedUser = Rx<Map<String, dynamic>>({});
}
