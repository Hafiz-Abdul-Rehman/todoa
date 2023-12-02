import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType keyboardType;
  final bool isObscure;
  final Function(String value)? onSubmitted;
  final Widget? trail;
  final Color color;
  final TextCapitalization? textCapitalization;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.isObscure,
    required this.keyboardType,
    this.onSubmitted,
    this.trail,
    this.textCapitalization,
    this.color = AppColors.ddOffWhite,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onSubmitted ?? (value) {},
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscure,
      style: AppTextStyles.sgRegStyle.copyWith(
        fontSize: 18,
        color: AppColors.blueBlack,
      ),
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
          suffixIcon: widget.trail,
          // suffixIcon: widget.trail == null ? Container(height: 0, width: 0,) : widget.trail,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: widget.hint,
          hintStyle: AppTextStyles.sgRegStyle.copyWith(
              fontSize: 18, color: AppColors.blueBlack.withOpacity(0.4)),
          filled: true,
          fillColor: widget.color,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.blueBlack.withOpacity(0.02)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.blueBlack.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}

class SecondCustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType keyboardType;
  final Widget? trail;
  final Color color;
  final int maxLines;

  const SecondCustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.keyboardType,
    this.trail,
    this.color = AppColors.ddOffWhite,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<SecondCustomTextField> createState() => _SecondCustomTextFieldState();
}

class _SecondCustomTextFieldState extends State<SecondCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.maxLines,
      maxLines: 5,
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: AppTextStyles.sgRegStyle.copyWith(
        fontSize: 18,
        color: AppColors.blueBlack,
      ),
      decoration: InputDecoration(
          suffixIcon: widget.trail,
          // suffixIcon: widget.trail == null ? Container(height: 0, width: 0,) : widget.trail,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: widget.hint,
          hintStyle: AppTextStyles.sgRegStyle.copyWith(
              fontSize: 18, color: AppColors.blueBlack.withOpacity(0.4)),
          filled: true,
          fillColor: widget.color,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.blueBlack.withOpacity(0.02)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.blueBlack.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}
