import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/closingDateModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClosingDateService {
  static const _viewUrl = "$apiUrl/get_closing_date";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _deleteUrlTime = "$apiUrl/delete_update";

  static const _addUrl = "$apiUrl/add_cdate";
  static const update_alldays = "$apiUrl/update_alldays";
  static const add_blockd = "$apiUrl/add_blockd";

  static List<ClosingDateModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<ClosingDateModel>.from(
        data.map((item) => ClosingDateModel.fromJson(item)));
  }

  static deleteData(String id) async {
    final res = await http.post(Uri.parse(_deleteUrl),
        body: {"id": id, "dbName": "closing_date"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteTime(String id) async {
    // print(id);
    final res = await http.post(Uri.parse(_deleteUrlTime),
        body: {"id": id, "dbName": "block_slots"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateAllday(String id, String allDay) async {
    final res = await http
        .post(Uri.parse(update_alldays), body: {"id": id, "all_day": allDay});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static addData(String date) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var doctId = preferences.getString("doctId");
    final res = await http
        .post(Uri.parse(_addUrl), body: {"doctId": doctId, "date": date});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static addBlockTime(String dateId, String opt, String clt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var doctId = preferences.getString("doctId");
    final res = await http.post(Uri.parse(add_blockd),
        body: {"doctId": doctId, "date_id": dateId, "opt": opt, "clt": clt});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static Future<List<ClosingDateModel>> getData(String doctId) async {
    final response = await http.get(Uri.parse("$_viewUrl?doctId=$doctId"));
    print(response.body);
    if (response.statusCode == 200) {
      List<ClosingDateModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
