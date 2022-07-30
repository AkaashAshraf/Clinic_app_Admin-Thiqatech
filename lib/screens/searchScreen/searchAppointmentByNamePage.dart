import 'package:demoadmin/screens/appointmentScreen/editAppointmetDetailsPage.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/fontStyle.dart';

class SearchAppointmentByNamePage extends StatefulWidget {
  @override
  _SearchAppointmentByNamePageState createState() =>
      _SearchAppointmentByNamePageState();
}

class _SearchAppointmentByNamePageState
    extends State<SearchAppointmentByNamePage> {
  bool _isEnableBtn = true;
  bool _isLoading = false;
  bool _isSearchedBefore = false;
  List appointmentDetails = [];
  TextEditingController _searchByNameController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose

    _searchByNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: SearchBoxWidget(
            controller: _searchByNameController,
            hintText: "Search patient name",
            validatorText: "Enter Name",
          ),
          actions: [
            SearchBtnWidget(
              onPressed: _handleSearchBtn,
              isEnableBtn: _isEnableBtn,
            )
          ],
        ),
        //Appbars.commonAppBar(context, "Appointments"),
        body: Container(child: cardListBuilder()));
  }

  _handleSearchBtn() async {
    final pattern = RegExp('\\s+'); //remove all space
    String searchByName = _searchByNameController.text
        .toLowerCase()
        .replaceAll(pattern, ""); //lowercase all letter and remove all space
    if (searchByName != "") {
      setState(() {
        _isLoading = true;
        _isSearchedBefore = true;
      });

      final res = await AppointmentService.getAppointmentByName(searchByName);

      setState(() {
        appointmentDetails = res;
        _isLoading = false;
      });
    }
  }

  Widget cardListBuilder() {
    return ListView(
      children: [
        // _buildSearchBoxContainer(),
        !_isSearchedBefore
            ? Container()
            : _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingIndicatorWidget(),
                  )
                : this.appointmentDetails.length > 0
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: this.appointmentDetails.length,
                        itemBuilder: (context, index) {
                          return patientDetailsCard(
                              this.appointmentDetails[index]);
                        },
                      )
                    : NoDataWidget(),
      ],
    );
  }

  Widget patientDetailsCard(appointmentDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ListTile(
            isThreeLine: true,
            title: Text(
              "${appointmentDetails.pFirstName + " " + appointmentDetails.pLastName}",
              style: kCardTitleStyle,
            ),
            trailing: editBtn(appointmentDetails),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8.0), child: Divider()),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Appointment Date:         ${appointmentDetails.appointmentDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Appointment Time:        ${appointmentDetails.appointmentTime}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Service Name:                ${appointmentDetails.serviceName}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text("Appointment Status:     "),
                      if (appointmentDetails.appointmentStatus == "Confirmed")
                        _statusIndicator(Colors.green)
                      else if (appointmentDetails.appointmentStatus ==
                          "Pending")
                        _statusIndicator(Colors.yellowAccent)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rejected")
                        _statusIndicator(Colors.red)
                      else if (appointmentDetails.appointmentStatus ==
                          "Rescheduled")
                        _statusIndicator(Colors.orangeAccent)
                      else
                        Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("${appointmentDetails.appointmentStatus}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  Widget editBtn(appointmentDetails) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAppointmentDetailsPage(
                    appointmentDetails: appointmentDetails),
              ),
            );
          },
          child: CircleAvatar(
              radius: 15.0,
              backgroundColor: btnColor,
              // foregroundColor: Colors.green,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              )),
        ));
  }
}
