import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/testimonialsModel.dart';

class TestimonialsService {
  static const _viewUrl = "$apiUrl/get_testimonials";
  static const _addUrl = "$apiUrl/add_testimonials";
  static const _deleteUrl = "$apiUrl/delete";
  static const _updateUrl = "$apiUrl/update_testimonial";

  static List<TestimonialsModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<TestimonialsModel>.from(
        data.map((item) => TestimonialsModel.fromJson(item)));
  }

  static Future<List<TestimonialsModel>> getData() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<TestimonialsModel> list = dataFromJson(response.body);

      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(TestimonialsModel testimonialsModel) async {
    final res = await http.post(Uri.parse(_addUrl),
        body: testimonialsModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteData(String id) async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>$id");
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "db": "testimonials"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(TestimonialsModel testimonialsModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: testimonialsModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
