// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:todoa/widgets/custom_text_field.dart';

// import '../constants/app_text_styles.dart';
// import '../constants/colors.dart';

// class TodoListScreen extends StatefulWidget {
//   final String priority;
//   const TodoListScreen({super.key, required this.priority});

//   @override
//   State<TodoListScreen> createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   final _controller = TextEditingController();
//   final _focusNode = FocusNode();

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//     _focusNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // String fullName = "Hafiz Abdul Rehman";
//     // List<String> nameParts = fullName.split(' ');
//     // String firstName = nameParts[0];

//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: AppColors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       // systemNavigationBarColor: AppColors.transparent,
//     ));

//     return Scaffold(
//         backgroundColor: AppColors.whiteColor,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: AppColors.whiteColor,
//           leadingWidth: 65,
//           leading: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: AppColors.blueBlack,
//               )),
//           title: Text(
//             widget.priority,
//             style: AppTextStyles.sgBoldStyle.copyWith(
//               fontSize: 19,
//               color: AppColors.blueBlack,
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(60),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: CustomTextField(
//                 controller: _controller,
//                 hint: "search a todo",
//                 focusNode: _focusNode,
//                 onSubmitted: (value) {
//                   FocusScope.of(context).unfocus();
//                 },
//                 keyboardType: TextInputType.text,
//                 isObscure: false,
//                 color: AppColors.dOffWhite,
//                 trail: IconButton(
//                   icon: Icon(
//                     CupertinoIcons.search,
//                     color: AppColors.blueBlack.withOpacity(0.8),
//                   ),
//                   onPressed: () {
//                     FocusScope.of(context).unfocus();
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             Text(
//             "Todo Tasks",
//             style: AppTextStyles.sgBoldStyle.copyWith(
//               fontSize: 19,
//               color: AppColors.blueBlack,
//             ),),
//             Expanded(
//               child: ListView.builder(
//                   itemCount: 20,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(index.toString()),
//                     );
//                   }),
//             ),
//           ],
//         ));
//   }
// }
