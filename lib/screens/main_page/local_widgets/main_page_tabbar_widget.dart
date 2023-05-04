import 'package:flutter/material.dart';
import 'package:mycampus/core/values/colors.dart';

class MainPageTabBarWidget extends StatefulWidget {
  final TabController tabController;
  final List<String> tabTitle;

  MainPageTabBarWidget({
    Key? key,
    required this.tabController,
    required this.tabTitle,
  }) : super(key: key);

  @override
  _MainPageTabBarWidgetState createState() => _MainPageTabBarWidgetState();
}

class _MainPageTabBarWidgetState extends State<MainPageTabBarWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(
          25.0,
        ),
        color: AppColor.kPrimaryBlue[100],
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      tabs: widget.tabTitle.map((title) {
        return Tab(
          text: title,
        );
      }).toList(),
    );
  }
}
