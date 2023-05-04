import 'package:mycampus/controller/auth_controller.dart';
import 'package:mycampus/core/themes/app_theme.dart';
import 'package:mycampus/core/values/firebase_constants.dart';
import 'package:mycampus/data/services/auth_service.dart';
import 'package:mycampus/screens/routes/routes.dart';
import 'package:mycampus/screens/welcome_page/welcome_page.dart';
import 'package:mycampus/screens/widget_test/widget_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((_) {
    Get.lazyPut(() => AuthService());
    Get.put(AuthController());
  });
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyCampus',
      theme: AppThemes.darkTheme,
      initialRoute: '/welcome-page',
      getPages: AppRoutes.routes,
    );
  }
}
