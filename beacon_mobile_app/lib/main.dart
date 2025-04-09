import 'package:beacon_mobile_app/firebase_options.dart';
import 'package:beacon_mobile_app/presentation/home_page.dart';
import 'package:beacon_mobile_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

   await dotenv.load(fileName: ".env"); 

  await NotificationService.instance.initialize();
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await NotificationService.registerFCMToken(
      token,
    ); 
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beacon Mobile App',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
