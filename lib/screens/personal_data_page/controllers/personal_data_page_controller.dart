import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mycampus/core/values/colors.dart';
import 'package:mycampus/core/values/firebase_constants.dart';
import 'package:mycampus/data/model/major_model.dart';
import 'package:mycampus/data/model/user_answers_model.dart';
import 'package:mycampus/data/services/user_service.dart';
import 'package:mycampus/screens/global_widgets/dot_loading.dart';
import 'package:mycampus/screens/main_page/main_page.dart';
import 'package:mycampus/screens/personal_data_page/data/interest_data.dart';
import 'package:mycampus/screens/personal_data_page/data/lifestyleq_data.dart';
import 'package:mycampus/screens/personal_data_page/data/majors_data.dart';
import 'package:mycampus/screens/personal_data_page/data/personalityq_data.dart';
import 'package:mycampus/screens/personal_data_page/local_widgets/major_bottom_sheet_widget.dart';
import 'package:mycampus/screens/search_partner_page/search_partner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:path_provider/path_provider.dart';

import '../../main_page/data/user_data.dart';

class PersonalDataPageController extends GetxController {
  final _userService = Get.find<UserService>();
  late final personalityData = Get.find<PersonalityQData>();
  late final majorData = Get.find<MajorsData>();
  late final lifestyleData = Get.find<LifestyleQData>();
  late final interestData = Get.find<InterestData>();
  final _imagePicker = ImagePicker();

  String _name = '';
  String _major = '';
  DateTime? _birthday;
  Rx<File?> profilePicture = Rx<File?>(null);
  Rx<String> gender = ''.obs;
  late LinkedScrollControllerGroup scrollController;
  late ScrollController personalityScrollController;
  late ScrollController lifeStyleScrollController;
  late TextEditingController nameTextController;
  late TextEditingController birthdayTextController;
  late TextEditingController majorTextController;
  late TextEditingController majorSearchTextController;
  Rx<double> backButtonOpacity = 1.0.obs;
  Rx<bool> isBackButtonVisible = true.obs;
  Rx<int> stepIndex = 0.obs;
  Rx<bool> isScrolling = false.obs;
  late Rx<bool> isLoading;
  List<String> interestList = [];
  late final bool isRetake;

  String get name => _name;
  DateTime? get birthday => _birthday;

  @override
  void onReady() {
    super.onReady();

    isLoading = Rx<bool>(false);

    ever<bool>(isLoading, (isLoading) {
      if (isLoading) {
        Get.defaultDialog(
          title: 'Loading',
          content: Container(
            height: 50,
            width: 50,
            child: Center(
              child: DotLoading(),
            ),
          ),
        );
      } else {
        Get.back();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = LinkedScrollControllerGroup();
    nameTextController = TextEditingController();
    birthdayTextController = TextEditingController();
    majorTextController = TextEditingController();
    majorSearchTextController = TextEditingController();
    personalityScrollController = scrollController.addAndGet();
    lifeStyleScrollController = scrollController.addAndGet();

    try {
      isRetake = Get.arguments['retake'];
    } catch (e) {
      isRetake = false;
    }

    if (isRetake) {
      stepIndex.value = 4;
      Get.find<UserService>()
          .getUser(auth.currentUser!.uid)
          .then((data) => gender.value = data.gender.toString());
    }

    scrollController.addOffsetChangedListener(() {
      // print(scrollController.offset);
      if (scrollController.offset < 50) {
        if (scrollController.offset < 0) {
          backButtonOpacity.value = 1.0;
          return;
        }
        backButtonOpacity.value = 1 - (scrollController.offset / 50);
        isBackButtonVisible.value = true;
      } else {
        backButtonOpacity.value = 0;
        isBackButtonVisible.value = false;
      }

      // if (scrollController.offset > 0) {
      //   isScrolling.value = true;
      // }
    });
  }

  @override
  void dispose() {
    personalityScrollController.dispose();
    lifeStyleScrollController.dispose();
    nameTextController.dispose();
    birthdayTextController.dispose();
    majorTextController.dispose();
    super.dispose();
  }

  set name(String value) {
    _name = value;
  }

  Future<bool> goBack() {
    if (stepIndex.value > 0) {
      if (stepIndex.value > 3 && isRetake) {
        return Future.value(true);
      }
      stepIndex.value--;
      scrollController.resetScroll();

      return Future.value(false);
    }

    return Future.value(true);
  }

  void goNext() {
    if (stepIndex.value < 7) {
      switch (stepIndex.value) {
        case 0:
          {
            if (nameTextController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: 'Please enter your name',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            } else if (nameTextController.text.length > 20) {
              Fluttertoast.showToast(
                msg: 'Name should be less than 20 characters',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            } else {
              _name = nameTextController.text;
              Get.focusScope?.unfocus();
            }
          }
          break;
        case 1:
          {
            if (gender.value == '') {
              Fluttertoast.showToast(
                msg: 'Please choose your gender',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            }
          }
          break;
        case 2:
          {
            if (_birthday == null) {
              Fluttertoast.showToast(
                msg: 'Please enter your birthday',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            } else if (_birthday!.isAfter(DateTime.now())) {
              Fluttertoast.showToast(
                msg: 'Birthday should be before today',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            }
          }
          break;
        case 3:
          {
            if (majorTextController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: 'Please enter your major',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            } else {
              _major = majorTextController.text;
              Get.focusScope?.unfocus();
            }
          }
          break;
        case 6:
          {
            if (interestList.isEmpty) {
              Fluttertoast.showToast(
                msg: 'Please select at least one interest',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColor.kAccentColor['blue'],
              );
              return;
            }
          }
          break;
        default:
      }
      stepIndex.value++;
      scrollController.resetScroll();
    } else {
      _submitData();
    }
  }

  Future getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profilePicture.value = File(pickedFile.path);
    }
  }

  Future<DateTime?> setBirthday(BuildContext context) async {
    _birthday = await showRoundedDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        borderRadius: 16,
        height: 280,
        theme: ThemeData(
          primarySwatch: AppColor.bluePalette,
        ));

    if (_birthday != null) {
      birthdayTextController.text =
          "${_birthday!.day}-${_birthday!.month}-${_birthday!.year}";
    }

    return _birthday;
  }

  void showMajorBottomSheet(context, List<MajorModel>? data) {
    print(data);
    if (data == null) {
      Fluttertoast.showToast(
        msg: 'No data found',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColor.kAccentColor['blue'],
      );
      return;
    }

    MajorBottomSheetWidget.majorBottomSheetWidget(context,
        majorTextController: majorTextController,
        data: data,
        searchTextController: majorSearchTextController);
  }

  void updatePersonalityAnswer(int index, double value) {
    personalityData.state![index].scaleAnswers = (value * 4).toInt() + 1;
    // // print(value);
    // print(personalityData.state![index].scaleAnswers);
  }

  void updateLifestyleAnswer(int index, bool value) {
    lifestyleData.state![index].answer = value;
  }

  void _submitData() async {
    List<int> personalityAnswers = [];
    List<bool> lifestyleAnswers = [];

    isLoading.value = true;

    for (var e in personalityData.state!) {
      personalityAnswers.add(e.scaleAnswers ?? 0);
    }
    for (var e in lifestyleData.state!) {
      lifestyleAnswers.add(e.answer ?? false);
    }

    _userService.addUserAnswers(
        uid: auth.currentUser!.uid,
        answers: UserAnswersModel(
          userId: auth.currentUser!.uid,
          lifestyleAnswer: lifestyleAnswers,
          personalityAnswer: personalityAnswers,
        ).toMap());

    // Upload default image if no image is selected
    if (profilePicture.value == null) {
      if (gender.string == "Male") {
        var response = await rootBundle
            .load('assets/images/default-profile-picture/male.png');
        final directory = await getApplicationDocumentsDirectory();
        var imageFile = File("${directory.path}/male.png");
        imageFile.writeAsBytesSync(response.buffer.asUint8List());

        profilePicture.value = imageFile;
      }
      if (gender.string == "Female") {
        var response = await rootBundle
            .load('assets/images/default-profile-picture/female.png');
        final directory = await getApplicationDocumentsDirectory();
        var imageFile = File("${directory.path}/female.png");
        imageFile.writeAsBytesSync(response.buffer.asUint8List());

        profilePicture.value = imageFile;
      }
    }

    String? profilePictureUrl = await _userService.uploadProfileImage(
        auth.currentUser!.uid, profilePicture.value!);

    _userService.addUserInterest(
      uid: auth.currentUser!.uid,
      interests: interestList,
    );

    String userMBTI =
        await _userService.calculateUserMBTI(auth.currentUser!.uid);

    if (!isRetake) {
      _userService.registerThirdStep(
        uid: auth.currentUser!.uid,
        name: _name,
        birthday: _birthday!,
        major: _major,
        gender: gender.value,
        interests: interestList,
        photoUrl: profilePictureUrl!,
        mbti: userMBTI,
      );
    } else {
      _userService.retakeUpdateData(
        uid: auth.currentUser!.uid,
        interests: interestList,
        photoUrl: profilePictureUrl!,
        mbti: userMBTI,
      );
    }

    print(userMBTI);

    isLoading.value = false;

    Get.offAllNamed(SearchPartnerPage.routeName, arguments: true);
  }
}
