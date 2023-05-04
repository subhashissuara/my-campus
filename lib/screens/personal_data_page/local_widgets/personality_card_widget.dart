import 'package:mycampus/screens/personal_data_page/local_widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalityCardWidget extends StatelessWidget {
  final String questionLeft;
  final String questionRight;
  final ValueChanged<double?> onChanged;
  final double initialValue;

  const PersonalityCardWidget({
    Key? key,
    required this.questionLeft,
    required this.questionRight,
    required this.onChanged,
    this.initialValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  questionLeft,
                  style: Get.textTheme.subtitle2!.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Flexible(
                child: Text(
                  questionRight,
                  style: Get.textTheme.subtitle2!.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          SliderWidget(
            fullWidth: true,
            min: 1,
            max: 5,
            onChanged: onChanged,
            value: initialValue,
          ),
        ],
      ),
    );
  }
}
