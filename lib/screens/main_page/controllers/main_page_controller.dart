import 'package:mycampus/data/services/auth_service.dart';
import 'package:mycampus/data/services/chat_service.dart';
import 'package:mycampus/data/services/user_service.dart';
import 'package:mycampus/screens/main_page/controllers/main_page_tabbar_controller.dart';
import 'package:mycampus/screens/main_page/data/user_data.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final AuthService authService = Get.find<AuthService>();
  final ChatService chatService = Get.find<ChatService>();
  final UserData userData = Get.find<UserData>();
  final MainPageTabBarController mainPageTabBarController =
      Get.find<MainPageTabBarController>();

  String getHeaderGreetings() {
    if (DateTime.now().hour < 12) {
      return 'Good Morning';
    } else if (DateTime.now().hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
