import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/departmentModel.dart';
import 'package:http/http.dart' as http;

class DepartmentService {
  static const _viewUrl = "$apiUrl/get_departmentbyid";
  static const _addUrl = "$apiUrl/add_department";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _updateUrl = "$apiUrl/update_department";

  static List<DepartmentModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<DepartmentModel>.from(
        data.map((item) => DepartmentModel.fromJson(item)));
  }

  static Future<List<DepartmentModel>> getData(
      String clinicId, String cityId) async {
    final response = await http
        .get(Uri.parse("$_viewUrl?clinicId=$clinicId&cityId=$cityId"));
    if (response.statusCode == 200) {
      List<DepartmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(DepartmentModel departmentModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: departmentModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "department"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(DepartmentModel serviceModel) async {
    print("${serviceModel.toUpdateJson()}");
    final res = await http.post(Uri.parse(_updateUrl),
        body: serviceModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
