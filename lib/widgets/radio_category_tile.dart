import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../constants/colors.dart';

class RadioCategoryTile extends StatelessWidget {
  final Color contentColor;
  final String title;
  final dynamic val;
  final dynamic groupVal;
  final Function(dynamic val) onChanged;
  const RadioCategoryTile({
    super.key,
    required this.contentColor,
    required this.groupVal,
    required this.val,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      contentPadding: const EdgeInsets.all(0),
      activeColor: contentColor,
      fillColor: MaterialStateProperty.all(contentColor),
      title: Transform.translate(
        offset: Offset(-16, 0),
        child: Text(
          title,
          style: AppTextStyles.sgRegStyle.copyWith(color: contentColor),
        ),
      ),
      value: val,
      groupValue: groupVal,
      onChanged: onChanged,
    );
  }
}
