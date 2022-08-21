import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/serviceModel.dart';

class SMTPService {
  static const _viewUrl = "https://api.emailjs.com/api/v1.0/email/send";

  static List<ServiceModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<ServiceModel>.from(
        data.map((item) => ServiceModel.fromJson(item)));
  }

  static Future sentMail(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(_viewUrl),
          headers: {
            'origin': 'http://localhost',
            "Content-Type": "application/json"
          },
          body: json.encode({
            'user_id': 'user_P3plcsDHVQ1v3uDhKvQWE',
            'service_id': 'service_clxgepv',
            'template_id': 'template_4wlo16l',
            'template_params': {
              'user_name': 'My clinic Admin',
              'user_email': "appwebdevash@gmail.com",
              'email_to': '$email',
              'user_subject': "Myclinic app forget doctor password ",
              'user_message':
                  'Your password is $password, please log in with this password then change your password'
            }
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        return "success";
      } else {
        return "error"; //if any error occurs then it return a blank list
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }
}
