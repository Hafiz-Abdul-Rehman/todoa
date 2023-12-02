import 'package:flutter/material.dart';
import 'package:todoa/widgets/sized_box_ex.dart';

import '../constants/app_text_styles.dart';
import '../constants/colors.dart';

class CategoryCardWidget extends StatefulWidget {
  final String title;
  final Color? iconColor;
  final Widget? icon;
  final String subtitle;
  final VoidCallback? onTap;

  const CategoryCardWidget({
    super.key,
    required this.title,
    this.iconColor,
    required this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  State<CategoryCardWidget> createState() => _CategoryCardWidgetState();
}

class _CategoryCardWidgetState extends State<CategoryCardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: widget.onTap ?? () {},
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 1.9,
        width: MediaQuery.of(context).size.width / 2.2,
        child: Card(
            elevation: 0,
            color: AppColors.ddOffWhite.withOpacity(0.7),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.blueBlack.withOpacity(0.03)),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.icon ??
                      Icon(
                        Icons.circle,
                        size: 15,
                        // color: AppColors.redColor.withOpacity(0.7),
                        color: widget.iconColor,
                      ),
                  10.ph,
                  Text(
                    widget.title,
                    style: AppTextStyles.sgBoldStyle.copyWith(
                      fontSize: 20,
                      color: AppColors.blueBlack,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.sgRegStyle.copyWith(
                      fontSize: 17,
                      color: AppColors.blueBlack.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
