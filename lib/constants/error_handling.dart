import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/constants/toast.dart';

void httpErrorHandle(
    {required http.Response response, required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showErrorToast(jsonDecode(response.body)["msg"]);
      break;
    case 500:
      showErrorToast(jsonDecode(response.body)["error"]);
      break;
    default:
      showErrorToast("Something went wrong");
  }
}
