import 'package:beacon_watch_app/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WatchNotificationScreen extends StatefulWidget {
  const WatchNotificationScreen({super.key});

  @override
  _WatchNotificationScreenState createState() =>
      _WatchNotificationScreenState();
}

class _WatchNotificationScreenState extends State<WatchNotificationScreen> {
  final NotificationController notificationController =
      Get.find<NotificationController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputField(titleController, 'Title'),
              SizedBox(height: 8.h),
              _buildInputField(bodyController, 'Body'),
              SizedBox(height: 12.h),
              _buildSendButton(),
              SizedBox(height: 10.h),
              Obx(
                () =>
                    notificationController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          notificationController.notificationResult.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp, color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
          contentPadding: EdgeInsets.symmetric(vertical: 6.h),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: () {
        notificationController.sendPushNotification(
          title: titleController.text,
          body: bodyController.text,
          data: {'key1': 'watch', 'key2': 'test'},
        );
      },  
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 8),
          ],
        ),
        child: Center(
          child: Text(
            'Send',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
