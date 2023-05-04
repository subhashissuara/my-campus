import 'package:mycampus/data/services/chat_service.dart';
import 'package:mycampus/data/services/user_service.dart';
import 'package:mycampus/screens/search_partner_page/search_partner_controller.dart';
import 'package:get/get.dart';

class SeacrhPartnerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserService>(() => UserService());
    Get.lazyPut<ChatService>(() => ChatService());
    Get.lazyPut<SearchPartnerController>(() => SearchPartnerController());
  }
}
