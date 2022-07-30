import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateData{
  static Future<String> updateTimeSlot(
      serviceTimeMin, timeSlots, date, appointmentId,doctId) async {
    List bookedTimeSlots = [];
    String res = "";
    final ref = FirebaseFirestore.instance
        .collection('bookedTimeSlots').doc(doctId).collection(doctId)
        .doc(
        date
    );
    await ref.get().then((snapshot) async {
      if (snapshot.data() == null) {
        //bookedTimeSlots = snapshot.data()["bookedTimeSlots"];
        bookedTimeSlots = [
          {
            "bookedTime": timeSlots,
            "forMin": serviceTimeMin,
            "appointmentId": appointmentId
          }
        ];
        await ref.set({"bookedTimeSlots": bookedTimeSlots}).catchError((e) {
          print(e);
          res = "error";
        });
      } else {
        bookedTimeSlots = snapshot.data()!["bookedTimeSlots"];
        bookedTimeSlots.add({
          "bookedTime": timeSlots,
          "forMin": serviceTimeMin,
          "appointmentId": appointmentId
        });

        await ref.update({"bookedTimeSlots": bookedTimeSlots}).catchError((e) {
          print(e);
          res = "error";
        });
      }
    }).catchError((e)  { res = "error";});
    return res;
  }
  static Future <String>updateToRescheduled(String appointmentId, String appointmentDate,String time,String newDate,int serviceTime,String doctId) async {
      String res="";
      final refBookedTimeSlots=FirebaseFirestore.instance.collection('bookedTimeSlots').doc(doctId).collection(doctId);

    final bookedAppointmentList=await refBookedTimeSlots.doc(appointmentDate).get().then((value) { return value["bookedTimeSlots"];}).catchError((onError){
      print(onError);
    });

        for (int i = 0; i < bookedAppointmentList.length; i++) {
          if (bookedAppointmentList[i]["appointmentId"] == appointmentId) {
            if (newDate == appointmentDate) {
              bookedAppointmentList[i]["bookedTime"] = time;
            } else {
              bookedAppointmentList.removeAt(i);
            }
          }
        }

        await refBookedTimeSlots.doc(
            appointmentDate).update({
          "bookedTimeSlots": bookedAppointmentList
        }).then((value) {
          res = "success";
        }).catchError((onError) {
          res = "error";
        });

        if (newDate != appointmentDate) {
          final resList = await refBookedTimeSlots.doc(newDate).get().then((value) {
            return value["bookedTimeSlots"];
          }).catchError((onError) {
            print(onError);
          });
          if (resList == null) {
            await refBookedTimeSlots
                .doc(
                newDate).set({
              "bookedTimeSlots": [{
                "appointmentId": appointmentId,
                "bookedTime": time,
                "forMin": serviceTime
              }
              ]
            })
                .then((value) {
              res = "success";
            }).catchError((onError) {
              res = "error";
            });
          }
          else if (resList != null) {
            resList.add({
              "bookedTime": time,
              "forMin": serviceTime,
              "appointmentId": appointmentId
            });
            await refBookedTimeSlots
                .doc(
                newDate).update({
              "bookedTimeSlots": resList
            })
                .then((value) {
              res = "success";
            }).catchError((onError) {
              res = "error";
            });
          }
        }
              return res;
  }



  static Future <String>updateTiming(String openingTime, String closingTime,String lunchOpeningTime,String lunchClosingTime,dayCode) async {
    final res =await FirebaseFirestore.instance.collection('timing') .doc("clinicTiming").update(
        {
          'clinicOpeningTime':openingTime,
          "clinicClosingTime":closingTime,
          'lunchOpeningTime':lunchOpeningTime,
          "lunchClosingTime":lunchClosingTime,
          "dayCode":dayCode
        }
    ).then((value) {return "success";}).catchError((onError){return"error";});
    return res;
  }
  static Future <String>updateSettings(sendData) async {

    final res =await FirebaseFirestore.instance.collection('settings')
        .doc("settings").update(
sendData
    ).then((value) {return "success";}).catchError((onError){return"error";});
    return res;
  }

  static Future <String>updateIsAnyNotification(String collection,String uId,bool isAnyNotification ) async {


    final res =await FirebaseFirestore.instance.collection(collection)
        .doc(uId).update(

        {
          "isAnyNotification":isAnyNotification
        }

    ).then((value) {return "success";}).catchError((onError){return"error";});
    return res;
  }
  static Future <String> updateIsAnyNotificationToALLUsers() async {
    String res="";

      final documents = await FirebaseFirestore.instance.collection("usersList")
          .get();
      for (var value in documents.docs) {
        await FirebaseFirestore.instance.collection("usersList").doc(value.id).update({
          "isAnyNotification":true
        });

      }

    return res;
  }


}