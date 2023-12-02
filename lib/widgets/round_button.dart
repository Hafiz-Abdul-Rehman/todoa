import 'package:flutter/material.dart';
import 'package:todoa/constants/colors.dart';

class RoundButton extends StatefulWidget {
  final Widget wChild;
  final VoidCallback onTapped;
  final bool loading;
  final isLogout;
  const RoundButton({
    Key? key,
    required this.wChild,
    required this.onTapped,
    this.loading = false,
    this.isLogout = false,
  }) : super(key: key);

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isLogout ? 65 : 55,
      width: double.infinity,
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          widget.isLogout ? BoxShadow(color: Colors.black87.withOpacity(0.0),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 0): BoxShadow(
              color: Colors.black87.withOpacity(0.4),
              offset: const Offset(2, 3),
              blurRadius: 6,
              spreadRadius: 0),
        ],
        borderRadius: BorderRadius.circular(widget.isLogout ? 15 : 10),
        color: AppColors.whiteColor,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          // surfaceTintColor: MaterialStateProperty.all(AppColors.whiteColor),
          splashFactory: InkRipple.splashFactory,
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.primaryColor
                    .withOpacity(0.9); // Specify the desired splash color here
              }else if(widget.isLogout){
                return AppColors
                    .whiteColor;
              }
              return AppColors
                  .primaryColor; // Specify the default button color here
            },
          ),
          // backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),

        onPressed: widget.onTapped,
        child: widget.loading
            ? CircularProgressIndicator(
                color: AppColors.whiteColor,
              )
            : widget.wChild,
      ),
      // child: Text("Login", style: AppTextStyles.sgBoldStyle.copyWith(
      //     color: AppColors.whiteColor, fontSize: 20),),
      // child: CircularProgressIndicator(color: AppColors.whiteColor,),
      // ),
    );
  }
}
