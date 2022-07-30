import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/adminNotificationModel.dart';

class AdminNotificationService {
  static const _viewUrl = "$apiUrl/get_admin_notification";
  static const _viewUrlByDoctId = "$apiUrl/get_admin_noti_by_doctid";

  static List<AdminNotificationModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AdminNotificationModel>.from(
        data.map((item) => AdminNotificationModel.fromJson(item)));
  }

  static Future<List<AdminNotificationModel>> getData(int getLimit) async {
    String limit = getLimit.toString();

    final response = await http.get(Uri.parse("$_viewUrl?limit=$limit"));
    if (response.statusCode == 200) {
      List<AdminNotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AdminNotificationModel>> getDataByDoctId(
      int getLimit, String doctId) async {
    String limit = getLimit.toString();
    print("$_viewUrlByDoctId?limit=$limit&id$doctId");

    final response =
        await http.get(Uri.parse("$_viewUrlByDoctId?limit=$limit&id="
            "$doctId"));
    if (response.statusCode == 200) {
      List<AdminNotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

// static addData(NotificationModel notificationModel)async{
  //   print(notificationModel.routeTo);
  //   final res=await http.post(Uri.parse(_addUrl),body:notificationModel.toJsonAdd());
  //   if(res.statusCode==200){
  //     return res.body;
  //   }
  //   else return "error";
  //
  // }

}
