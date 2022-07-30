import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/serviceModel.dart';

class ServiceService {
  static const _viewUrl = "$apiUrl/get_service";
  static const _addUrl = "$apiUrl/add_service";
  static const _deleteUrl = "$apiUrl/delete";
  static const _updateUrl = "$apiUrl/update_service";

  static List<ServiceModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<ServiceModel>.from(
        data.map((item) => ServiceModel.fromJson(item)));
  }

  static Future<List<ServiceModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));

    if (response.statusCode == 200) {
      List<ServiceModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(ServiceModel serviceModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: serviceModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "db": "service"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(ServiceModel serviceModel) async {
    print("${serviceModel.toUpdateJson()}");
    final res = await http.post(Uri.parse(_updateUrl),
        body: serviceModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
