import 'dart:convert';

import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/cityModel.dart';
import 'package:http/http.dart' as http;

class CityService {
  static const _viewUrl = "$apiUrl/get_city";
  static const _addUrl = "$apiUrl/add_city";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _updateUrl = "$apiUrl/update_city";

  static List<CityModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<CityModel>.from(data.map((item) => CityModel.fromJson(item)));
  }

  static Future<List<CityModel>> getData() async {
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<CityModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(CityModel cityModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: cityModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "city"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(CityModel cityModel) async {
    print("${cityModel.toUpdateJson()}");
    final res =
        await http.post(Uri.parse(_updateUrl), body: cityModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
