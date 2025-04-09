import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notificationResult = ''.obs;

  final String apiKey = dotenv.env['AUTH_API_KEY'] ?? '';
  final String appwriteEndpoint =
      dotenv.env['APPWRITE_CLOUD_FUNCTION_ENDPOINT'] ?? '';

  
  Future<void> sendPushNotification({
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    isLoading.value = true;
    notificationResult.value = '';



    if (appwriteEndpoint.isEmpty) {
      isLoading.value = false;
      return;
    }

    if (apiKey.isEmpty) {
      isLoading.value = false;
      return;
    }

   
   

    
    final Map<String, dynamic> requestBody = {
      'title': title,
      'body': body,
      'data': data,
    };

    final String jsonBody = jsonEncode(requestBody);
    print("📩 Request Body: $jsonBody");

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };

    try {
      print("📡 Sending HTTP POST Request...");
      final response = await http.post(
        Uri.parse(appwriteEndpoint),
        headers: headers,
        body: jsonBody,
       
      );

   

      if (response.statusCode == 200) {
        notificationResult.value =
            '✅ Notification sent successfully: ${response.body}';
      } else {
        notificationResult.value =
            '⚠️ Error sending notification: ${response.statusCode} - ${response.body}';
      }
    } catch (error) {
   
      notificationResult.value = '❌ Error during HTTP request: $error';
    } finally {
      isLoading.value = false;
    }
  }
}
