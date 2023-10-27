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
      "x-auth-token": isImportant
          ? "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjJlMjBjZGM0LTRhMjMtNDQ5Yy1hZWYzLTkwMzk0NmJmZTk1NCIsIm5hbWUiOiJqa2xqIiwidXNlcm5hbWUiOiJrbGpsa2prbGprbGoiLCJlbWFpbCI6InFhYmR1bDg0NEBnbWFpbC5jb20iLCJwYXNzd29yZCI6IiQyYSQwOCRrMVZDL0Z5SEZmSW1HZ3dHVjFIZ1NlU1hmdFprcnUyM3BIbndUYXhmRHBtY2UvS2RvaUt0RyIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjdUMTU6MTI6MjQuNjgwWiIsInVwZGF0ZWRBdCI6IjIwMjMtMTAtMjdUMTU6MTI6MjQuNjgwWiIsImlhdCI6MTY5ODQxOTU0NH0.u6o-9BOlmFBO4Kdy6DC11rc3-rQSZ52hgX07JLe2v2s"
          : ""
    },
  );
  print(res);
  httpErrorHandle(response: res, onSuccess: success);

  return res;
}
