import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoa/constants/colors.dart';
import 'package:todoa/firebase_options.dart';
import 'package:todoa/providers/auth_provider.dart';
import 'package:todoa/providers/category_provider.dart';
import 'package:todoa/providers/date_time_provider.dart';
import 'package:todoa/providers/todo_provider.dart';
import 'package:todoa/widgets/new_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
    // systemNavigationBarColor: AppColors.transparent,
  ));
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.notification!.title.toString());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => DateTimeProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'Todoa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          primarySwatch: AppColors.customPrimaryColor,
          scaffoldBackgroundColor: AppColors.dOffWhite,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primaryColor,
            selectionColor: AppColors.lightPrimaryColor,
            selectionHandleColor: AppColors.darkPrimaryColor,
          ),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyCustomSplashScreen(),
      ),
    );
  }
}

/*

web       1:923604832175:web:3ba1cc9c49cd0aaa3be95a
android   1:923604832175:android:23fa3b96b3151d903be95a
ios       1:923604832175:ios:0cba4eda3129ebea3be95a

* */

