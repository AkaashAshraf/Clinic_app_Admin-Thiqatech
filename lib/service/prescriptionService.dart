import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/prescriptionModel.dart';

class PrescriptionService {
  static const _viewUrl = "$apiUrl/get_prescription";
  static const _viewUrlById = "$apiUrl/get_prescription_byid";
  static const _updateData = "$apiUrl/update_prescription";
  static const _addUrl = "$apiUrl/add_prescription";
  static const _deleteUrl = "$apiUrl/delete";

  static List<PrescriptionModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<PrescriptionModel>.from(
        data.map((item) => PrescriptionModel.fromJson(item)));
  }

  static Future<List<PrescriptionModel>> getData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final response =
        await http.post(Uri.parse(_viewUrl), body: {"uId": userId});
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<PrescriptionModel>> getDataByApId(
      {String? appointmentId, String? uid}) async {
    print(appointmentId);
    print(uid);

    final response = await http.post(Uri.parse(_viewUrlById),
        body: {"uId": uid, "appointmentId": appointmentId});
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future updateData(PrescriptionModel prescriptionModel) async {
    final response = await http.post(Uri.parse(_updateData),
        body: prescriptionModel.toJsonUpdate());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static Future addData(PrescriptionModel prescriptionModel) async {
    final response = await http.post(Uri.parse(_addUrl),
        body: prescriptionModel.toJsonAdd());
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "db": "prescription"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
