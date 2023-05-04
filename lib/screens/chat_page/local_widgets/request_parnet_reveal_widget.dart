import 'package:mycampus/core/values/colors.dart';
import 'package:mycampus/screens/global_widgets/glow_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class RequestPartnerRevealWidget extends StatelessWidget {
  const RequestPartnerRevealWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8F8F8F).withOpacity(0.15),
                offset: const Offset(0, 4),
                blurRadius: 27,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.check,
                color: AppColor.kPrimaryBlue[100]!,
                size: 32,
              ),
              SizedBox(width: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Your request has been\nsent',
                    style: Get.textTheme.subtitle1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Wait for your partner to accept',
                    style: Get.textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
