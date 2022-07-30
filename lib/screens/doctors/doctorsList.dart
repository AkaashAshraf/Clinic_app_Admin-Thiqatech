import 'package:demoadmin/screens/doctors/addDoctorsPage.dart';
import 'package:demoadmin/screens/doctors/editDoctDetailsPage.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class DoctorsList extends StatefulWidget {
  final clinicId;
  final cityId;
  final deptID;
  DoctorsList({this.cityId, this.clinicId, this.deptID});
  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          title: "Add Doctor",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDoctorsPage(
                    deptID: widget.deptID,
                    cityId: widget.cityId,
                    clinicId: widget.clinicId),
              ),
            );
          },
          isEnableBtn: true,
        ),
        appBar: IAppBars.commonAppBar(context, "All Doctors"),
        body: FutureBuilder(
            future: DrProfileService.getAllDr(widget.clinicId, widget.cityId,
                widget.deptID), //fetch images form database
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData)
                return snapshot.data.length == 0
                    ? NoDataWidget()
                    : _buildContent(snapshot.data);
              else if (snapshot.hasError)
                return IErrorWidget(); //if any error then you can also use any other widget here
              else
                return LoadingIndicatorWidget();
            }));
  }

  _buildContent(listDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: .6,
        crossAxisCount: 2,
        children: List.generate(listDetails.length, (index) {
          return _cardImg(listDetails[
              index]); //send type details and index with increment one
        }),
      ),
    );
  }

  _cardImg(listDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditDoctDetialsPage(
              clinicId: widget.clinicId,
              cityId: widget.cityId,
              drDetails: listDetails,
            ),
          ),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 90,
                  child: listDetails.profileImageUrl == "" ||
                          listDetails.profileImageUrl == null
                      ? Icon(Icons.image)
                      : ImageBoxFillWidget(
                          imageUrl: listDetails.profileImageUrl)),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 90,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Dr. " +
                                listDetails.firstName +
                                " " +
                                listDetails.lastName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                          ),
                          Text(
                            listDetails.hName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
