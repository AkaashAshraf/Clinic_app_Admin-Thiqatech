import 'dart:convert';
import 'dart:developer';

import 'package:demoadmin/model/categoryModel.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  static const _viewUrl = "$apiUrl/get_all_categories";
  static const _addUrl = "$apiUrl/add_category";
  static const _deleteUrl = "$apiUrl/delete_category";
  static const _updateUrl = "$apiUrl/update_category";

  static List<CategoryModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<CategoryModel>.from(data.map((item) => CategoryModel.fromJson(item)));
  }

  static Future<List<CategoryModel>> getData() async {
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<CategoryModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(String name, String nameAr) async {
    log(nameAr);
    final res =
    await http.post(Uri.parse(_addUrl), body: {'name_en': name, 'name_ar': nameAr});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"category_id": id});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(String id, String name, String nameAr) async {
    final res =
    await http.post(Uri.parse(_updateUrl), body: {'category_id': id, 'name_en': name, 'name_ar': nameAr});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
