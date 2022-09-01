import 'package:demoadmin/screens/appointmentTypeScreen/addAppointmentTypes.dart';
import 'package:demoadmin/screens/appointmentTypeScreen/editAppointmentTypesPage.dart';
import 'package:demoadmin/service/appointmentTypeService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/colors.dart';

import '../../utilities/appbars.dart';

class AppointmentTypesPage extends StatefulWidget {
  @override
  _AppointmentTypesPageState createState() => _AppointmentTypesPageState();
}

class _AppointmentTypesPageState extends State<AppointmentTypesPage> {
  bool _isenableBtn = true;
  bool _isLoading = false;
  String _disableStartTime = "";
  String _disableEndTime = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAndSetTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Appointment Types"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isenableBtn,
          onPressed: _handleAddTypes,
          title: "Add Appointment Types",
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Container(
                child: FutureBuilder(
                    future: AppointmentTypeService.getData(),
                    //fetch all appointment types
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData)
                        return snapshot.data.length == 0
                            ? NoDataWidget()
                            : buildGridView(snapshot.data);
                      else if (snapshot.hasError)
                        return IErrorWidget(); //if any error then you can also use any other widget here
                      else
                        return LoadingIndicatorWidget();
                    })));
  }

  _handleAddTypes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAppointmentTypesPage(
          disableStartTime: _disableStartTime,
          disableEndTime: _disableEndTime,
        ),
      ),
    );
  }

  Widget buildGridView(appointmentTypesDetails) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8, bottom: 8),
      child: GridView.count(
        childAspectRatio: .9,
        crossAxisCount: 2,
        children: List.generate(appointmentTypesDetails.length, (index) {
          return _cardImg(appointmentTypesDetails[index]);
        }),
      ),
    );
  }

  Widget _cardImg(appointmentTypesDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Card(
                //color: Colors.red,
                // color: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10.0,
              ),
              // color: Colors.yellowAccent,
            ),
            Positioned(
              top: 1,
              left: 4,
              right: 4,
              bottom: 50,
              child: Container(
                  // height:double.infinity,
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.all(00.0),
                      child: appointmentTypesDetails.imageUrl == ""
                          ? Icon(
                              Icons.category_outlined,
                              color: primaryColor,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: ImageBoxFillWidget(
                                  imageUrl: appointmentTypesDetails.imageUrl)
                              //get image
                              ))),
            ),
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(appointmentTypesDetails.titleEn,
                    style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 12.0,
                    )),
              ),
            ),
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: 10,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(appointmentTypesDetails.subTitleEn,
                    style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 12.0,
                    )),
              ),
            ),
            Positioned(
                top: 0, //you can change the position of edit button
                left: 0,
                child: _editBtn(appointmentTypesDetails)),
          ],
        ),
      ),
    );
  }

  Widget _editBtn(appointmentTypesDetails) {
    return EditBtnWidget(
      title: "Edit",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditAppointmentTypes(
              disableStartTime: _disableStartTime,
              disableEndTime: _disableEndTime,
              appointmentTypesDetails: appointmentTypesDetails,
            ),
          ),
        );
      },
    );
  }

  void _getAndSetTime() async {
    print("ssssssss");
    setState(() {
      _isLoading = true;
    });
    // final res = await ReadData.fetchOpeningClosingTime();
    setState(() {
      _disableStartTime = '13:51:36';
      _disableEndTime = '13:51:36';
      _isLoading = false;
    });
  }
}
