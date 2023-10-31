import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:social_media/controllers/mainController.dart';
import 'package:social_media/controllers/userController.dart';
import 'package:social_media/themes/dark_theme.dart';
import 'package:social_media/themes/light_theme.dart';
import 'package:social_media/views/authentication/login.dart';
import 'package:social_media/views/authentication/otp.dart';
import 'package:social_media/views/main/home.dart';
import 'package:social_media/views/main/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());

  SharedPreferences sp = await SharedPreferences.getInstance();
  if (sp.getString("token") != null) {
    String? id = sp.getString("token");
    authController.decodedToken.value = JwtDecoder.decode(id!);
    authController.token.value = sp.getString("token")!;
    authController.userId.value = authController.decodedToken.value["id"];
    print(authController.userId.value);
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: authController.token.isNotEmpty ? UserNavigationBar() : Login());
  }
}
