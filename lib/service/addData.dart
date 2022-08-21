
import 'package:cloud_firestore/cloud_firestore.dart';
class AddData {

  static Future<String> addNotiDetails(doctId) async {
    var sendData = {"isAnyNotification": false};
    String res = "";
    await FirebaseFirestore.instance
        .collection('doctorsNoti')
        .doc(doctId)
        .set(sendData)
        .then((value) {
      res = "success";
    }).catchError((onError) {
      print(onError);
      res = "error";
    });
    return res;
  }

}
