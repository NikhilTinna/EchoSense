import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/constants/toast.dart';
import '../controllers/authController.dart';
import 'error_handling.dart';
import 'global.dart';

Future<http.Response> get(String endpoint) async {
  return await http.get(Uri.parse("$url/$endpoint"));
}

Future<http.Response> post(
    {required String endpoint,
    required var body,
    required VoidCallback success,
    bool isImportant = true}) async {
  AuthController authController = Get.put(AuthController());
  http.Response res = await http.post(
    Uri.parse(endpoint),
    body: body,
    headers: <String, String>{
      'Content-Type': "application/json; charset=UTF-8",
      "x-auth-token": isImportant ? authController.userId.value : ""
    },
  );
  print(res);
  httpErrorHandle(response: res, onSuccess: success);

  return res;
}
