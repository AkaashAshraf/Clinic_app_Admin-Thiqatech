import 'dart:developer';

import 'package:demoadmin/screens/appointmentScreen/appChooseTimeSlotPage.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/dialogBox.dart';

class AppAppointmentPage extends StatefulWidget {
  final doctId;
  final lunchOpTime;
  final lunchCloTime;
  final closingDate;
  final serviceTime;
  final dayCode;
  final copt;
  final cclt;
  final deptName;
  final doctName;
  final hospitalName;
  final stopBooking;
  final fee;
  final clinicId;
  final cityId;
  final deptId;
  final cityName;
  final clinicName;
  final userModel;
  AppAppointmentPage(
      {Key? key,
      this.doctId,
      this.lunchCloTime,
      this.lunchOpTime,
      this.closingDate,
      this.deptName,
      this.doctName,
      this.hospitalName,
      this.serviceTime,
      this.dayCode,
      this.cclt,
      this.copt,
      this.stopBooking,
      this.fee,
      this.cityId,
      this.clinicId,
      this.deptId,
      this.cityName,
      this.clinicName,
      this.userModel})
      : super(key: key);

  @override
  _AppAppointmentPageState createState() => _AppAppointmentPageState();
}

class _AppAppointmentPageState extends State<AppAppointmentPage> {
  List appointmentTypesDetails = [
    {"title": "Online", "imageUrl": "assets/icons/online.png"},
    {"title": "Offline", "imageUrl": "assets/icons/offline.png"}
  ];
  bool _isLoading = false;
  void initState() {
    // TODO: implement initState

    _checkStopBookingStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, widget.doctName),
        body: _isLoading ? LoadingIndicatorWidget() : _buildContent());
  }

  Widget _buildContent() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildGridView(appointmentTypesDetails),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(appointmentTypesDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: .9,
        crossAxisCount: 2,
        children: List.generate(appointmentTypesDetails.length, (index) {
          return _cardImg(appointmentTypesDetails[index],
              index + 1); //send type details and index with increment one
        }),
      ),
    );
  }

  Widget _cardImg(
    appointmentTypesDetails,
    num num,
  ) {
    //  print(appointmentTypesDetails.day);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppChooseTimeSlotPage(
              serviceName: appointmentTypesDetails["title"],
              serviceTimeMin: int.parse(widget.serviceTime),
              openingTime: widget.copt,
              closingTime: widget.cclt,
              closedDay: widget.dayCode,
              lunchOpTime: widget.lunchOpTime,
              lunchCloTime: widget.lunchCloTime,
              drClosingDate: widget.closingDate,
              doctName: widget.doctName,
              hospitalName: widget.hospitalName,
              deptName: widget.deptName,
              doctId: widget.doctId,
              stopBooking: widget.stopBooking,
              fee: widget.fee,
              clinicId: widget.clinicId,
              cityId: widget.cityId,
              deptId: widget.deptId,
              cityName: widget.cityName,
              clinicName: widget.clinicName,
              userModel: widget.userModel,
            ),
          ),
        );
      },
      child: Container(
        //  height: MediaQuery.of(context).size.height * .2,
        // width:  MediaQuery.of(context).size.width*.15,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          child: Stack(
            clipBehavior: Clip.none,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Image.asset(
                      appointmentTypesDetails['imageUrl'],
                      fit: BoxFit.fill,
                    ) //get images
                    ),
              ),
              Positioned.fill(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        color: primaryColor,
                        child: Center(
                          child: Text(
                              appointmentTypesDetails["title"] == "Online"
                                  ? "Video Consultation"
                                  : "Hospital Visit",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 12.0,
                              )),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void _checkStopBookingStatus() async {
    setState(() {
      _isLoading = true;
    });
    log("LLLLLLLLLLLLLLLLLLLLL${widget.stopBooking}");
    final res = await ReadData.fetchSettings(); //fetch settings details
    if (res != null) if (res["stopBooking"])
      DialogBoxes.stopBookingAlertBox(context, "Sorry!",
          "We are currently not accepting new appointments. we will start soon");
    else if (widget.stopBooking == "true")
      DialogBoxes.stopBookingAlertBox(context, "Sorry!",
          "${widget.doctName} is not accepting new appointments");
    setState(() {
      _isLoading = false;
    });
  }
}
