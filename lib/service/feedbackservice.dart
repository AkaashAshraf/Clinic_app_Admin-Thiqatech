import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/feedbackmodel.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  static const _addUrl = "$apiUrl/add_feedback";
  static const _getUrl = "$apiUrl/get_feedbacklist";

  static List<FeedbackModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<FeedbackModel>.from(
        data.map((item) => FeedbackModel.fromJson(item)));
  }

  static Future<List<FeedbackModel>> getData(int getLimit) async {
    String limit = getLimit.toString();
    final response = await http.get(Uri.parse("$_getUrl?limit=$limit"));
    if (response.statusCode == 200) {
      List<FeedbackModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(FeedbackModel feedbackModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: feedbackModel.addJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
