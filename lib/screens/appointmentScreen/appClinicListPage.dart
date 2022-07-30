import 'package:demoadmin/screens/appointmentScreen/appDepartmentPage.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';

import '../../service/clinicService.dart';

class AppClinicListPage extends StatefulWidget {
  final cityId;
  final cityName;
  final userModel;
  AppClinicListPage({this.cityId, this.cityName, this.userModel});
  @override
  _AppClinicListPageState createState() => _AppClinicListPageState();
}

class _AppClinicListPageState extends State<AppClinicListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.cityName),
      // bottomNavigationBar: BottomNavigationStateWidget(
      //   title: "Next",
      //   onPressed: () {
      //
      //   },
      //   clickable: "true"//_serviceName,
      // ),
      body: FutureBuilder(
          future:
              ClinicService.getData(widget.cityId), //fetch images form database
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildContent(snapshot.data);
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  _buildContent(listDetails) {
    return ListView.builder(
        itemCount: listDetails.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _cardImg(listDetails[index]);
        });
  }

  _cardImg(listDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppChooseDepartmentPage(
              cityId: widget.cityId,
              cityName: widget.cityName,
              clinicId: listDetails.id,
              clinicName: listDetails.title,
              clinicLocationName: listDetails.locationName,
              userModel: widget.userModel,
            ),
          ),
        );
      },
      child: Card(
        //color: bgColor,
        elevation: .5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: listDetails.imageUrl == "" ||
                              listDetails.imageUrl == null
                          ? Icon(Icons.image)
                          : ImageBoxFillWidget(
                              imageUrl: listDetails.imageUrl))),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    listDetails.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                  ),
                  Text(
                    listDetails.locationName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      // child: Card(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10.0),
      //     ),
      //     child: Stack(
      //       children: [
      //         Positioned(
      //             top: 0,
      //             left: 0,
      //             right: 0,
      //             bottom: 45,
      //             child: ImageBoxFillWidget(imageUrl: listDetails.imageUrl)),
      //         Positioned(
      //             bottom: 0,
      //             left: 0,
      //             right: 0,
      //             child: Container(
      //               height: 45,
      //               child: Center(
      //                 child: Text(
      //                   listDetails.title,
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                       fontSize: 14, fontFamily: "OpenSans-SemiBold"),
      //                 ),
      //               ),
      //             )),
      //       ],
      //     )),
    );
  }
}
