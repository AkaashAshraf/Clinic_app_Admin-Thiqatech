import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/blogPostModel.dart';
import 'package:http/http.dart' as http;

class BlogPostService {
  static const _viewUrl = "$apiUrl/get_blog_post";
  static const _addUrl = "$apiUrl/add_blog_post";
  static const _deleteUrl = "$apiUrl/delete_blog_post";
  static const _updateUrl = "$apiUrl/update_blog_post";

  static List<BlogPostModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<BlogPostModel>.from(
        data.map((item) => BlogPostModel.fromJson(item)));
  }

  static Future<List<BlogPostModel>> getData(int getLimit) async {
    final String limit = getLimit.toString();
    final response = await http.get(Uri.parse("$_viewUrl?limit=$limit"));
    if (response.statusCode == 200) {
      List<BlogPostModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(BlogPostModel blogPostModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: blogPostModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteData(String id, String fileName) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "fileName": fileName});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(BlogPostModel blogPostModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: blogPostModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
