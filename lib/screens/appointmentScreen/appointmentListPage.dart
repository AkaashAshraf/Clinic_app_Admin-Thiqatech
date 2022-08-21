import 'package:demoadmin/model/appointmentModel.dart';
import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/screens/appointmentScreen/editAppointmetDetailsPage.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/appointmentTypeService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/pdfApi.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppointmentListPage extends StatefulWidget {
  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  bool _isEnableBtn = true;
  String userType = "";
  String doctId = "";
  int limit = 20;
  int itemLength = 0;
  bool isMoreData = false;
  List<String> _appointmentTypes = [];
  List<String> _selectedTypes = [];
  List<AppointmentModel> appModel = [];
  List<DrProfileModel> doctorsList = [];
  List<String> selectedDoctorsId = [];
  List<String> _allStatus = [
    "Pending",
    "Rescheduled",
    "Rejected",
    "Confirmed",
    "Visited",
    "Canceled"
  ];
  final newDate = new DateTime.now();
  String _firstDate = "All"; //DateTime.now().toString();
  String _lastDate = "All"; // DateTime.now().toString();
  // var _selectedFirstDate = new DateTime.now();
  //var _selectedLastDate = new DateTime.now();
  List<String> _selectedStatus = [];
  bool _isLoading = false;
  ScrollController _scrollController = new ScrollController();
  DateRangePickerSelectionChangedArgs? argsDate;
  DateRangePickerSelectionChangedArgs? argsDatePdf;
  String firstDate = "All";
  String lastDate = "All";

  @override
  void initState() {
    _firstDate = newDate.year.toString() +
        "-" +
        newDate.month.toString() +
        "-" +
        newDate.day.toString();
    ;
    _lastDate = newDate.year.toString() +
        "-" +
        newDate.month.toString() +
        "-" +
        newDate.day.toString();
    ;
    // TODO: implement initState
    _scrollListener();
    _getSetData();

    super.initState();
  }

  _getSetData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userType = preferences.getString('userType') ?? "";
    if (preferences.getString('doctId') != null)
      doctId = preferences.getString('doctId') ?? "";

    final res = await AppointmentTypeService.getData();
    for (var type in res) {
      setState(() {
        _appointmentTypes.add(type.titleEn ?? '');
      });
    }
    final resDoct = await DrProfileService.getDoctors();
    setState(() {
      doctorsList = resDoct;
    });
    setState(() {
      _selectedTypes.addAll(_appointmentTypes);
      _selectedStatus.addAll(_allStatus);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _filteredAppBar(context, "Appointments"),
        bottomNavigationBar: BottomNavTwoBarWidget(
          secondTitle:
              userType == "doctor" ? "Search By ID" : "Filter By Doctor",
          secondBtnOnPressed:
              userType == "doctor" ? _handleByIdBtn : showDialogBoxDoctor,
          isenableBtn: _isEnableBtn,
          firstTitle: "Search By Name",
          firstBtnOnPressed: _handleByNameBtn,
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: Icon(
                Icons.filter_alt_sharp,
                color: Colors.white,
              ),
              onPressed: showDialogBox,
            ),
            backgroundColor: btnColor,
            onPressed: () {}),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Container(child: cardListBuilder()));
  }

  cDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(''),
            content: Container(
              //   height: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 250,
                    width: 250,
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: argsDate?.value.startDate == null &&
                              argsDate?.value.endDate == null
                          ? null
                          : PickerDateRange(
                              argsDate!.value.startDate,
                              argsDate!.value.endDate,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "OK",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    if (argsDate!.value.startDate != null &&
                        argsDate!.value.endDate != null) {
                      var pickedStartDate = DateFormat('yyyy-MM-dd')
                          .format(argsDate!.value.startDate);
                      var pickedEndDate = DateFormat('yyyy-MM-dd')
                          .format(argsDate!.value.endDate);
                      print(DateFormat('yyyy-MM-dd')
                          .format(argsDate!.value.startDate));
                      print(DateFormat('yyyy-MM-dd')
                          .format(argsDate!.value.endDate));
                      setState(() {
                        _firstDate =
                            pickedStartDate; //_setTodayDateFormat(picked.first);
                        _lastDate =
                            pickedEndDate; // _setTodayDateFormat(picked.last);
                      });
                      Navigator.of(context).pop();
                    } else
                      ToastMsg.showToastMsg("select date range");
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  _handleByIdBtn() {
    Navigator.pushNamed(context, "/SearchAppointmentByIdPage");
  }

  _handleByNameBtn() {
    Navigator.pushNamed(context, "/SearchAppointmentByNamePage");
  }

  _filteredAppBar(context, String title) {
    return AppBar(
      // iconTheme: IconThemeData(
      //   color: Colors.white, //change your color here
      // ),
      title: Text(
        title,
        style: kAppBarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(Icons.date_range), onPressed: _openDialogForDate)),
        _isLoading
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.merge_type_sharp,
                      color: Colors.white,
                    ),
                    onPressed: cDialogBoxPdf
                    //  showDialogBoxByType
                    ))
      ],
    );
  }

  Widget cardListBuilder() {
    return FutureBuilder(
        future: userType == "doctor"
            ? AppointmentService.getDataBYDoctId(
                _selectedStatus, _firstDate, _lastDate, limit, doctId)
            : AppointmentService.getData(
                _selectedStatus,
                //  _selectedTypes,
                _firstDate,
                _lastDate,
                selectedDoctorsId,
                limit), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) if (snapshot.data.length == 0)
            return NoDataWidget();
          else {
            itemLength = snapshot.data.length;
            return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _card(snapshot.data, index);
              },
            );
          }
          else if (snapshot.hasError)
            return IErrorWidget(); //if any error then you can also use any other widget here
          else
            return LoadingIndicatorWidget();
        });
  }

  showDialogBoxDoctor() {
    List newStatus = [];
    newStatus.addAll(selectedDoctorsId);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Select Doctor"),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: doctorsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: primaryColor,
                        title: Text(doctorsList[index].firstName +
                            " " +
                            doctorsList[index].lastName),
                        value: newStatus.contains(doctorsList[index].id),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue!)
                              newStatus.add(doctorsList[index].id);
                            else
                              newStatus.remove(doctorsList[index].id);
                          });
                          print('DOCTOR RESPONSE'+newStatus.toString());
                        });
                  }),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("OK"),
                  onPressed: () {
                    _handleStatusDoct(newStatus);
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  showDialogBox() {
    List<String> newStatus = [];
    newStatus.addAll(_selectedStatus);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose a status"),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _allStatus.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: Colors.black,
                        title: Text(_allStatus[index]),
                        value: newStatus.contains(_allStatus[index]),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue!)
                              newStatus.add(_allStatus[index]);
                            else
                              newStatus.remove(_allStatus[index]);
                          });
                        });
                  }),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "OK",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _handleStatus(newStatus);
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  showDialogBoxByType() {
    List<String> newStatus = [];
    newStatus.addAll(_selectedTypes);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose a type"),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _appointmentTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        activeColor: iconsColor,
                        title: Text(_appointmentTypes[index]),
                        value: newStatus.contains(_appointmentTypes[index]),
                        onChanged: (newValue) {
                          setState(() {
                            if (!newStatus.contains(_appointmentTypes[index]))
                              newStatus.add(_appointmentTypes[index]);
                            else
                              newStatus.remove(_appointmentTypes[index]);
                            print(newStatus.length);
                          });
                        });
                  }),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("OK"),
                  onPressed: () {
                    _handleTypes(newStatus);
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  _handleTypes(newStatus) {
    if (newStatus.length == 0) {
      ToastMsg.showToastMsg("please Select at least one");
    } else if (newStatus.length > 0) {
      _selectedTypes.clear();
      setState(() {
        _selectedTypes.addAll(newStatus);
      });
    }
  }

  _handleStatus(newStatus) {
    if (newStatus.length == 0) {
      ToastMsg.showToastMsg("please Select at least one");
    } else if (newStatus.length > 0) {
      _selectedStatus.clear();
      setState(() {
        _selectedStatus.addAll(newStatus);
      });
    }
  }

  _handleStatusDoct(newStatus) {
    if (newStatus.length == 0) {
      setState(() {
        selectedDoctorsId.clear();
      });
    } else if (newStatus.length > 0) {
      selectedDoctorsId.clear();
      for (int i = 0; i < newStatus.length; i++) {
        setState(() {
          selectedDoctorsId.add(newStatus[i]);
        });
      }
    }
  }

  String _subTitleWithSpace(String subTitle) {
    String string = subTitle;

    for (int i = 0; i < 24 - subTitle.length; i++) {
      string = string + "  ";
    }
    return string;
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
                      "${_subTitleWithSpace("Doctor:")}${appointmentDetails.doctName}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: appointmentDetails.isOnline == "true"
                      ? Text("${_subTitleWithSpace("Appointment")}Online")
                      : Text("${_subTitleWithSpace("Appointment")}Offline"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Id:")}${appointmentDetails.id}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Gender:")}${appointmentDetails.gender}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Age:")}${appointmentDetails.age}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Mobile Number:")}${appointmentDetails.pPhn}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Date:")}${appointmentDetails.appointmentDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Time:")}${appointmentDetails.appointmentTime}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      "${_subTitleWithSpace("Appointment Type:")}${appointmentDetails.serviceName}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text("${_subTitleWithSpace("Appointment Status:")} "),
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
    return EditIconBtnWidget(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditAppointmentDetailsPage(
                appointmentDetails: appointmentDetails),
          ),
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    argsDate = args;
  }

  void _onSelectionChangedPdf(DateRangePickerSelectionChangedArgs args) {
    argsDatePdf = args;
  }

  _openDialogForDate() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Text("Choose"),
          content: Text(
              "Tap on All to get appointment of all dates\n\nTap on Date to pick a date range"),
          actions: <Widget>[
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text("Today", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  setState(() {
                    final newDate = new DateTime.now();
                    print(newDate);
                    _firstDate = newDate.year.toString() +
                        "-" +
                        newDate.month.toString() +
                        "-" +
                        newDate.day.toString();
                    _lastDate = newDate.year.toString() +
                        "-" +
                        newDate.month.toString() +
                        "-" +
                        newDate.day.toString();
                  });
                  Navigator.pop(context);
                }),
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text("All", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  setState(() {
                    _firstDate = "All";
                    _lastDate = "All";
                  });
                  Navigator.pop(context);
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text(
                  "Date",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // onPressed();
                  Navigator.pop(context);
                  cDialogBox();
                  // _dateRangePicker();
                })
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      // print("length" $itemLength $limit");
      if (itemLength >= limit) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            limit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }

  cDialogBoxPdf() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(''),
            content: Container(
              //   height: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 250,
                    width: 250,
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChangedPdf,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange:
                          argsDatePdf?.value.startDate == null &&
                                  argsDatePdf?.value.endDate == null
                              ? null
                              : PickerDateRange(
                                  argsDatePdf!.value.startDate,
                                  argsDatePdf!.value.endDate,
                                ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "OK",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    if (argsDatePdf!.value.startDate != null &&
                        argsDatePdf!.value.endDate != null) {
                      var pickedStartDate = DateFormat('yyyy-MM-dd')
                          .format(argsDatePdf!.value.startDate);
                      var pickedEndDate = DateFormat('yyyy-MM-dd')
                          .format(argsDatePdf!.value.endDate);
                      // print(DateFormat('yyyy-MM-dd').format(argsDate!.value.startDate));
                      // print(DateFormat('yyyy-MM-dd').format(argsDate!.value.endDate));
                      setState(() {
                        //_selectedFirstDate = argsDate!.value.startDate;
                        //_selectedLastDate= argsDate!.value.endDate;
                        firstDate =
                            pickedStartDate; //_setTodayDateFormat(picked.first);
                        lastDate =
                            pickedEndDate; // _setTodayDateFormat(picked.last);
                      });
                      generatePdf();
                      Navigator.of(context).pop();
                    } else
                      ToastMsg.showToastMsg("select date range");
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void generatePdf() async {
    // String firstDate="All";
    // String lastDate="All";
    // final  picked = await DateRangePicker.showDatePicker(
    //     context: context,
    //     initialFirstDate: _selectedFirstDate,
    //     initialLastDate: _selectedLastDate,
    //     firstDate: new DateTime(2021),
    //     lastDate: new DateTime(2050));
    // if (picked != null) {
    //   setState(() {
    //     firstDate = _setTodayDateFormat(picked.first);
    //     lastDate = _setTodayDateFormat(picked.last);
    //   });
    // }
    var status = await Permission.storage.request();

    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else if (status.isGranted) {
      print("Granted");
      if (userType == "doctor") {
        final appModel = await AppointmentService.getDataPdf(
            _selectedStatus, firstDate, lastDate, doctId, limit);
        final pdfFile = await PdfApi.generateTable(appModel);

        PdfApi.openFile(pdfFile);
      } else {
        final appModel = await AppointmentService.getDataPdf(
            _selectedStatus, firstDate, lastDate, "", limit);
        final pdfFile = await PdfApi.generateTable(appModel);

        PdfApi.openFile(pdfFile);
      }
    }

// You can can also directly ask the permission about its status.
  }

  Widget _card(appointmentDetails, int index) {
    print("${appointmentDetails[index].clinicName}");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditAppointmentDetailsPage(
                appointmentDetails: appointmentDetails[index]),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _appointmentDate(
                appointmentDetails[index].appointmentDate,
              ),
              // VerticalDivider(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("Name: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 12,
                              )),
                          Text(
                              appointmentDetails[index].pFirstName ?? ''+
                                  " " +
                                  appointmentDetails[index].pLastName ?? '',
                              style: TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Time: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 12,
                              )),
                          Text(appointmentDetails[index].appointmentTime,
                              style: TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 15,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  height: 1, color: Colors.grey[300])),
                          Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: appointmentDetails[index]
                                          .appointmentStatus ==
                                      "Pending"
                                  ? _statusIndicator(Colors.yellowAccent)
                                  : appointmentDetails[index]
                                              .appointmentStatus ==
                                          "Rescheduled"
                                      ? _statusIndicator(Colors.orangeAccent)
                                      : appointmentDetails[index]
                                                  .appointmentStatus ==
                                              "Rejected"
                                          ? _statusIndicator(Colors.red)
                                          : appointmentDetails[index]
                                                      .appointmentStatus ==
                                                  "Confirmed"
                                              ? _statusIndicator(Colors.green)
                                              : null),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                            child: Text(
                              appointmentDetails[index].appointmentStatus,
                              style: TextStyle(
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      // Text(
                      //     appointmentDetails[index].clinicName +
                      //         "  " +
                      //         appointmentDetails[index].cityName,
                      //     style: TextStyle(
                      //       fontFamily: 'OpenSans-Regular',
                      //       fontSize: 12,
                      //     )),
                      Text(appointmentDetails[index].doctName,
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 12,
                          )),
                      Text(
                          appointmentDetails[index].serviceName == "Online"
                              ? "Video Consultation"
                              : "Hospital Visit",
                          style: TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 15,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appointmentDate(date) {
    var appointmentDate = date.split("-");
    var appointmentMonth;
    switch (appointmentDate[0]) {
      case "1":
        appointmentMonth = "JAN";
        break;
      case "2":
        appointmentMonth = "FEB";
        break;
      case "3":
        appointmentMonth = "MARCH";
        break;
      case "4":
        appointmentMonth = "APRIL";
        break;
      case "5":
        appointmentMonth = "MAY";
        break;
      case "6":
        appointmentMonth = "JUN";
        break;
      case "7":
        appointmentMonth = "JULY";
        break;
      case "8":
        appointmentMonth = "AUG";
        break;
      case "9":
        appointmentMonth = "SEP";
        break;
      case "10":
        appointmentMonth = "OCT";
        break;
      case "11":
        appointmentMonth = "NOV";
        break;
      case "12":
        appointmentMonth = "DEC";
        break;
    }

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(appointmentMonth,
            style: TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              fontSize: 15,
            )),
        Text(appointmentDate[1],
            style: TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              color: btnColor,
              fontSize: 35,
            )),
        Text(appointmentDate[2],
            style: TextStyle(
              fontFamily: 'OpenSans-SemiBold',
              fontSize: 15,
            )),
      ],
    );
  }
}
