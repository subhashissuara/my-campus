import 'package:mycampus/core/values/firebase_constants.dart';
import 'package:mycampus/data/model/interest_model.dart';
import 'package:mycampus/data/model/user_model.dart';
import 'package:mycampus/data/services/user_service.dart';
import 'package:get/get.dart';

class UserData extends GetxController with StateMixin<UserModel> {
  @override
  void onInit() {
    super.onInit();
    Get.find<UserService>().getUser(auth.currentUser!.uid).then(
          (value) => change(
            value,
            status: RxStatus.success(),
          ),
        );
  }
}
