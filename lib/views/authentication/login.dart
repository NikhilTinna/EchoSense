import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 100, // Set the desired width for your container
                  height: 160, // Set the desired height for your container

                  child: Image.asset(
                    'assets/images/logo.png', // Replace with the path to your image
                    fit: BoxFit
                        .fill, // Use BoxFit.fill to force the image to fill the container
                  ),
                ),
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
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.purple, // Background color
                                  onPrimary: Colors
                                      .amber, // Text Color (Foreground color)
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Login",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )),
                          ),
                        )
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
