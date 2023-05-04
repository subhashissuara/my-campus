import 'package:mycampus/data/model/interest_model.dart';
import 'package:mycampus/data/model/major_model.dart';
import 'package:mycampus/data/services/question_service.dart';
import 'package:get/get.dart';

class InterestData extends GetxController with StateMixin<List<InterestModel>> {
  @override
  void onInit() {
    super.onInit();
    Get.find<QuestionService>().getAllInterest().then(
          (value) => change(
            value,
            status: RxStatus.success(),
          ),
        );
  }
}
