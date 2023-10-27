import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/views/authentication/signup.dart';

import '../../constants/REST_api.dart';
import '../../constants/toast.dart';
import '../../controllers/authController.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.background)),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 70, // Set the desired width for your container
                    height: 110, // Set the desired height for your container

                    child: Image.asset(
                      'assets/images/logo.png', // Replace with the path to your image
                      fit: BoxFit
                          .fill, // Use BoxFit.fill to force the image to fill the container
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.07,
                ),
                Row(
                  children: [
                    Text(
                      "  Login",
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
                            height: 15,
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
                                            "http://10.0.2.2:3000/user/signin",
                                        body: jsonEncode({
                                          "email": emailController.text,
                                          "password": passwordController.text
                                        }),
                                        success: () {
                                          showSuccessToast(
                                              "logged in Successfully");
                                        },
                                        isImportant: false);
                                    if (res.statusCode == 200) {
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      sp.setString("token", res.body);
                                      AuthController authController =
                                          Get.put(AuthController());
                                      authController.decodedToken.value =
                                          JwtDecoder.decode(
                                              sp.getString("token")!);
                                      authController.token.value =
                                          sp.getString("token")!;
                                    }
                                  },
                                  child: Text(
                                    "Login",
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
                                "Don't have an account? ",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Signup();
                                  }));
                                },
                                child: const Text(
                                  "Create one ",
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
