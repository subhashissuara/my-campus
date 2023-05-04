import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageTabBarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final int tabLength;

  MainPageTabBarController({required this.tabLength});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
