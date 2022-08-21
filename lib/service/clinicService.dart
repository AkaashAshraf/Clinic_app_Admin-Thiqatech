import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/clinicModel.dart';
import 'package:http/http.dart' as http;

class ClinicService {
  static const _viewUrl = "$apiUrl/get_clinic";
  static const _addUrl = "$apiUrl/add_clinic";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _updateUrl = "$apiUrl/update_clinic";

  static List<ClinicModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<ClinicModel>.from(
        data.map((item) => ClinicModel.fromJson(item)));
  }

  static Future<List<ClinicModel>> getData(String cityId) async {
    final response = await http.get(Uri.parse("$_viewUrl?cityId=$cityId"));
    if (response.statusCode == 200) {
      List<ClinicModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(ClinicModel clinicModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: clinicModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "clinic"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(ClinicModel clinicModel) async {
    //  print("${clinicModel.toUpdateJson()}");
    final res = await http.post(Uri.parse(_updateUrl),
        body: clinicModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
