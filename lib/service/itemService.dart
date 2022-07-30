import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:demoadmin/model/itemModel.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:dio/dio.dart';

import '../config.dart';

class ItemService {
  static const _viewUrl = "$apiUrl/get_all_items";
  static const _addUrl = "$apiUrl/add_item";
  static const _deleteUrl = "$apiUrl/delete_item";
  static const _updateUrl = "$apiUrl/update_item";

  static List<ItemModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<ItemModel>.from(data.map((item) => ItemModel.fromJson(item)));
  }

  static Future<List<ItemModel>> getData() async {
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<ItemModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(
      String name, String quantity, List<File> images, List<String> ids, String detail, String price, String nameAr, String detailAr) async {
        log(nameAr + ' detal   ' + price);
    String concatenate = ids.join(',');
    log('ids: ${concatenate}');
    FormData formData = FormData.fromMap({
      "name_en": name,
      "name_ar": nameAr,
      "quantity": quantity,
      "category_ids": concatenate.toString(),
      "item_details_en": detail,
      "item_details_ar": detailAr,
      "share_price": price,
      "images[]": [
        for (var i in images)
          await MultipartFile.fromFile(i.path,
              filename: i.path.split('/').last),
      ]
    });
    log(formData.fields.toString());
    final res = await Dio().post(_addUrl, data: formData);

    // log(imagePathList.toString());
    // var request = await http.MultipartRequest('POST', Uri.parse(_addUrl));
    // request.fields.addAll({
    //   'name': name,
    //   'quantity': quantity
    // });
    // for (var image in images) {
    //   final path = await getFilePath(image);
    //   request.files.add(await http.MultipartFile.fromPath('images[]', path));
    // }
    // http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      log(res.data);
      return res.data;

      // return await res.stream.bytesToString;
    } else
      return "error";
  }

  static deleteData(String id) async {
    final res = await http.post(Uri.parse(_deleteUrl), body: {"item_id": id});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(
      String name, String quantity, String itemId, List<File> images, List<String> ids, String nameAr, String detailAr, String detail, String price) async {
        log('nameAr: $nameAr, detailAr: $detail');
        String concatenate = ids.join(',');
    log('itme update: ${concatenate}');
    FormData formData = FormData.fromMap({
      "item_id": itemId,
      "name_en": name,
      "name_ar": nameAr,
      "quantity": quantity,
      "share_price": price,
      "item_details_en": detail,
      "item_details_ar": detailAr,
      "category_ids": concatenate.toString(),
      "images[]": [
        for (var i in images)
          await MultipartFile.fromFile(i.path,
              filename: i.path.split('/').last),
      ]
    });
    log('itme update: ${formData.fields}');
    final res = await Dio().post(_updateUrl, data: formData);

    // final res = await http.post(Uri.parse(_updateUrl),
    //     body: {});
    if (res.statusCode == 200) {
      return res.data;
    } else
      return "error";
  }

  static getFilePath(images) async {
    String? path = await FlutterAbsolutePath.getAbsolutePath(
        images.identifier); //get path of the image from asset
    return path;
  }
}
