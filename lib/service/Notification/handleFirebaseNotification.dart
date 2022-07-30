import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:demoadmin/service/Notification/handleLocalNotification.dart';
import 'package:http/http.dart' as http;

class HandleFirebaseNotification {
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  static handleNotifications(context) async {
    // await FirebaseMessaging.instance.unsubscribeFromTopic(
    //     "all"); //scribe user to this all group so we can send message to multiple device
    // print("===========admin un subscribe=========");
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        badge: true,
        alert: true,
        sound:
            true); //presentation options for Apple notifications when received in the foreground.

    FirebaseMessaging.onMessage.listen((message) async {
      print('Got a message whilst in the FOREGROUND!');

      return;
    }).onData((data) {
      HandleLocalNotification.showNotification(
          data.data["title"], data.data["body"]);
      print('Got a DATA message whilst in the FOREGROUND!');

      print('data from  onMessage stream: ${data.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('NOTIFICATION MESSAGE TAPPED');
      return;
    }).onData((data) {
      print('NOTIFICATION MESSAGE TAPPED');
      print('data from onMessageOpenedApp stream: ${data.data}');
      Navigator.pushNamed(context, "/NotificationListPage");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then(
        (value) => value != null ? _firebaseMessagingBackgroundHandler : false);
    return;
  }

  static Future<void> sendPushMessage(
      String token, String title, String body) async {
    String serverKey = firebaseServerKey;

    String _token = token;
    // if (_token == null) {
    //   print('Unable to send FCM message, no token exists.');
    //   return;
    // }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey'
        },
        body: constructFCMPayload(_token, title, body),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  static String constructFCMPayload(String token, String title, String body) {
    return jsonEncode({
      "to": token,
      "notification": {
        "sound": "default",
        "body": body,
        "title": title,
        "content_available": true,
        "priority": "high"
      },
      "data": {
        "sound": "default",
        "body": body,
        "title": title,
        "content_available": true,
        "priority": "high"
      }
    });
  }
}
