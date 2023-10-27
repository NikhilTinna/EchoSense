import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/views/main/home.dart';
import 'package:social_media/views/main/navigation_bar.dart';
import '../../constants/REST_api.dart';
import '../../constants/toast.dart';
import '../../controllers/authController.dart';
import 'package:http/http.dart' as http;

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  AuthController authController = Get.put(AuthController());
  List<String> enteredOTP = ["0", "0", "0", "0"];

  @override
  void initState() {
    super.initState();

    // Initialize controllers and focus nodes for each OTP digit
    controllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());

    // Add listeners to move focus to the next digit when a digit is entered
    for (int i = 0; i < 3; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes to prevent memory leaks
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              left: Get.width * 0.025, right: Get.width * 0.025, top: 20),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Verification Code",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "OTP sent to ${authController.unverifiedUser.value["email"]} ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 50,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            enteredOTP[index] = value;

                            setState(() {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index]);
                            });
                          }
                        },
                      ),
                    );
                  }),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String otp = enteredOTP.join("");
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      if (otp != sp.getString("otp")) {
                        showErrorToast("Invalid OTP Entered");
                      } else {
                        http.Response res = await post(
                            endpoint: "http://10.0.2.2:3000/user/signup",
                            body:
                                jsonEncode(authController.unverifiedUser.value),
                            success: () {
                              showSuccessToast("Account Created Successfully");
                            },
                            isImportant: false);
                        if (res.statusCode == 200) {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString("token", res.body);
                          AuthController authController =
                              Get.put(AuthController());
                          authController.decodedToken.value =
                              JwtDecoder.decode(sp.getString("token")!);
                          authController.token.value = sp.getString("token")!;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return UserNavigationBar();
                          }));
                        }
                      }
                    },
                    child: Text("Enter OTP"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
