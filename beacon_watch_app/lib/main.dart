import 'package:beacon_watch_app/controller/notification_controller.dart';
import 'package:beacon_watch_app/firebase_options.dart';
import 'package:beacon_watch_app/presentation/base_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: ".env"); 
     
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  Get.put(NotificationController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Wrap your app with ScreenUtilInit
      designSize: const Size(
        360,
        360,
      ), // Adjust this based on your target watch resolution
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Watch Notification App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: WatchNotificationScreen(), // Always display the watch screen
        );
      },
    );
  }
}
