import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/availabilityModel.dart';
import 'package:http/http.dart' as http;

class AvailabilityService {
  static const _viewUrl = "$apiUrl/get_availability";
  static const _updateUrl = "$apiUrl/update_availability";

  static List<AvailabilityModel> availabilityFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AvailabilityModel>.from(
        data.map((item) => AvailabilityModel.fromJson(item)));
  }

  static Future<List<AvailabilityModel>> getAvailability() async {
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      List<AvailabilityModel> list = availabilityFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(AvailabilityModel availabilityModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: availabilityModel.toUpdateJson());
    print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
