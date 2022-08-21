import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/notificationModel.dart';

class NotificationService {
  static const _viewUrl = "$apiUrl/get_all_notification";
  static const _addUrl = "$apiUrl/add_notification";
  static const _addAdminUrl = "$apiUrl/add_admin_notification";

  static List<NotificationModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<NotificationModel>.from(
        data.map((item) => NotificationModel.fromJson(item)));
  }

  static Future<List<NotificationModel>> getData(int getLimit) async {
    String limit = getLimit.toString();

    final user = FirebaseAuth.instance.currentUser;
    final response =
        await http.get(Uri.parse("$_viewUrl?uid=${user!.uid}&limit=$limit"));
    if (response.statusCode == 200) {
      List<NotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(NotificationModel notificationModel) async {
    print(notificationModel.routeTo);
    final res = await http.post(Uri.parse(_addUrl),
        body: notificationModel.toJsonAdd());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static addDataForAdmin(NotificationModel notificationModel) async {
    final res = await http.post(Uri.parse(_addAdminUrl),
        body: notificationModel.toJsonAddForAdmin());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
