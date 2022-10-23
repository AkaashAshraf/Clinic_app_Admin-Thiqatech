import 'package:demoadmin/screens/prescription/addPrescriptionPage.dart';
import 'package:demoadmin/screens/prescription/editprescriptionDetails.dart';
import 'package:demoadmin/service/prescriptionService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class PrescriptionListByIDPage extends StatefulWidget {
  final drName;
  final appointmentId;
  final userId;
  final patientName;
  final date;
  final time;
  final serviceName;
  final serviceNameAr;
  PrescriptionListByIDPage(
      {this.drName,
      this.appointmentId,
      this.userId,
      this.patientName,
      this.time,
      this.serviceName,
      this.serviceNameAr,
      this.date});
  @override
  _PrescriptionListByIDPageState createState() =>
      _PrescriptionListByIDPageState();
}

class _PrescriptionListByIDPageState extends State<PrescriptionListByIDPage> {
  final ScrollController _scrollController = new ScrollController();
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.patientName),
      //  bottomNavigationBar: BottomNavigationWidget(route: "/ContactUsPage", title:"Contact us"),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: Icon(Icons.add),
          backgroundColor: btnColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPrescriptionPage(
                        drName: widget.drName,
                        title: "Add New Prescription",
                        patientName: widget.patientName,
                        serviceName: widget.serviceName,
                        serviceNameAr: widget.serviceNameAr,
                        date: widget.date,
                        time: widget.time,
                        appointmentId: widget.appointmentId,
                        patientId: widget.userId,
                      )),
            );
          }),
      body: FutureBuilder(
          future: PrescriptionService.getDataByApId(
              appointmentId: widget.appointmentId, uid: widget.userId),
          //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 0.0, left: 8, right: 8),
                      child: _buildCard(snapshot.data));
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  Widget _buildCard(prescriptionDetails) {
    // _itemLength=notificationDetails.length;
    return ListView.builder(
        controller: _scrollController,
        itemCount: prescriptionDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrescriptionDetailsPage(
                        title: prescriptionDetails[index].appointmentName,
                        prescriptionDetails: prescriptionDetails[index])),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text(prescriptionDetails[index].appointmentName,
                        style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 14.0,
                        )),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: iconsColor,
                      size: 20,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${prescriptionDetails[index].patientName}",
                          style: TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${prescriptionDetails[index].appointmentDate} ${prescriptionDetails[index].appointmentTime}",
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }
}
