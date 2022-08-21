import 'dart:convert';
import 'dart:developer';
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/galleryModel.dart';

class GalleryService {
  static const _viewUrl = "$apiUrl/get_gallery";
  static const _addUrl = "$apiUrl/add_galleryImage";
  static const _deleteUrl = "$apiUrl/delete";

  static List<GalleryModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<GalleryModel>.from(
        data.map((item) => GalleryModel.fromJson(item)));
  }

  static Future<List<GalleryModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<GalleryModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(GalleryModel galleryModel) async {
    log('gallery image: ' +galleryModel.imageUrl);
    final res =
        await http.post(Uri.parse(_addUrl), body: galleryModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "db": "gallery"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
