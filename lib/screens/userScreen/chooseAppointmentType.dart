import 'package:demoadmin/screens/userScreen/newAppointmetTime.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

import '../../service/appointmentTypeService.dart';

class ChooseTypePage extends StatefulWidget {
  final userDetails;

  ChooseTypePage({Key? key, this.userDetails}) : super(key: key);
  @override
  _ChooseTypePageState createState() => _ChooseTypePageState();
}

class _ChooseTypePageState extends State<ChooseTypePage> {
  var _number;
  int _serviceTimeMin = 0;
  String _serviceName = "";
  String _openingTime = "";
  String _closingTime = "";
  String closedDay = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Types"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _serviceName == "" ? false : true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewAppointmentTimePage(
                  serviceName: _serviceName,
                  serviceTimeMin: _serviceTimeMin,
                  openingTime: _openingTime,
                  closingTime: _closingTime,
                  closedDay: closedDay,
                  userDetails: widget.userDetails,
                ),
              ),
            );
          },
          title: "Next",
        ),
        body: _buildContent());
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 20, right: 10, bottom: 10),
              child: Center(
                  child: Text("What type of appointment",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 15.0,
                      )))),
          FutureBuilder(
              future: AppointmentTypeService
                  .getData(), //fetch all appointment types
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData)
                  return snapshot.data.length == 0
                      ? NoDataWidget()
                      : _buildGridView(snapshot.data);
                else if (snapshot.hasError)
                  return IErrorWidget(); //if any error then you can also use any other widget here
                else
                  return LoadingIndicatorWidget();
              }),
        ],
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
    print(appointmentTypesDetails.day);
    return GestureDetector(
      onTap: () {
        _serviceTimeMin = appointmentTypesDetails.forTimeMin;
        setState(() {
          if (_number == num) {
            //if user again tap
            setState(() {
              this._serviceName = ""; //clear name
              _number = 0;
              //set to zero
            });
          } else {
            //if user taps
            setState(() {
              this._serviceName =
                  appointmentTypesDetails.title; //set the service name
              this._serviceTimeMin =
                  appointmentTypesDetails.forTimeMin; //set the service time
              //every appointment has defrent defrent time scheduled
              this._openingTime = appointmentTypesDetails.openingTime;
              this._closingTime = appointmentTypesDetails.closingTime;
              this.closedDay = appointmentTypesDetails.day;
            });

            _number = num; //set the number to taped card index+1
          }
        });
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
                    child: ImageBoxFillWidget(
                      imageUrl: appointmentTypesDetails.imageUrl,
                    ) //get images
                    ),
              ),
              Positioned.fill(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: num ==
                              _number //if tap card value index+1 match with number value it mean user tap on the card
                          ? Container(
                              width: double.infinity,
                              height: 40,
                              color: btnColor,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(appointmentTypesDetails.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        )),
                                    Text(appointmentTypesDetails.subTitle,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        ))
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 40,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(appointmentTypesDetails.title,
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        )),
                                    Text(appointmentTypesDetails.subTitle,
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 12.0,
                                        )),
                                  ],
                                ),
                              ),
                            )))
            ],
          ),
        ),
      ),
    );
  }
}
