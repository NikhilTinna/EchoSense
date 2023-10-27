import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString userId = "".obs;
  Rx<Map<String, dynamic>> decodedToken = Rx<Map<String, dynamic>>({});
}
