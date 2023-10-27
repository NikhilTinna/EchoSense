import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/constants/toast.dart';

import 'package:social_media/views/authentication/login.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/views/authentication/otp.dart';

import '../../controllers/authController.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.primary)),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.07,
                ),
                Row(
                  children: [
                    Text(
                      "  Create Account",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " Name",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "Enter name",
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            " Username",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "Enter Username",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            " Email",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "Enter email",
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            " Password",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "Enter password",
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () async {
                                    http.Response res = await post(
                                        endpoint:
                                            "http://10.0.2.2:3000/user/verify",
                                        body: jsonEncode({
                                          "name": nameController.text,
                                          "username": usernameController.text,
                                          "email": emailController.text,
                                          "password": passwordController.text
                                        }),
                                        success: () {
                                          showSuccessToast(
                                              "An OTP has been sent to your email");
                                        },
                                        isImportant: false);
                                    if (res.statusCode == 200) {
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      sp.setBool("isVerified", false);
                                      AuthController authController =
                                          Get.put(AuthController());
                                      authController.unverifiedUser.value = {
                                        "name": nameController.text,
                                        "username": usernameController.text,
                                        "email": emailController.text,
                                        "password": passwordController.text
                                      };
                                      sp.setString("otp", res.body);
                                      Get.to(OTP());
                                    }
                                  },
                                  child: Text(
                                    "Create Account",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Login();
                                  }));
                                },
                                child: const Text(
                                  "Login ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ],
            )),
      ),
    );
  }
}
