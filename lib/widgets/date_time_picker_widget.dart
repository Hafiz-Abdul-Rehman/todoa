import "package:flutter/material.dart";
import "package:todoa/widgets/sized_box_ex.dart";

import "../constants/app_text_styles.dart";
import "../constants/colors.dart";

class DateTimePickerWidget extends StatelessWidget {
  final String uTitle;
  final String iTitle;
  final IconData icon;
  final VoidCallback onPressed;
  const DateTimePickerWidget({
    super.key,
    required this.uTitle,
    required this.iTitle,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              uTitle,
              style: AppTextStyles.sfBoldStyle.copyWith(
                fontSize: 22,
                color: AppColors.blueBlack,
              ),
            ),
          ),
          8.ph,
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onPressed,
            child: Container(
              height: 50,
              // width: MediaQuery.sizeOf(context).width * 0.43,
              // padding: EdgeInsets.only(left: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.ddOffWhite.withOpacity(0.6),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: AppColors.blueBlack.withOpacity(0.8),
                  ),
                  8.pw,
                  Text(
                    iTitle,
                    style: AppTextStyles.sfRegStyle.copyWith(
                      fontSize: 17,
                      color: AppColors.blueBlack.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
