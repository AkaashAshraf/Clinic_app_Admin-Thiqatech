import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:demoadmin/model/appointmentModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/dateAndTimeCalculation.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:intl/intl.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class ChooseTimeSlotsPage extends StatefulWidget {
  final serviceTimeMin;
  final appointmentId;
  final appointmentDate;
  final uId;
  final uName;
  final serviceName;
  final serviceNameAr;
  final doctId;
  const ChooseTimeSlotsPage(
      {Key? key,
      this.serviceTimeMin,
      this.appointmentId,
      this.appointmentDate,
      this.uId,
      this.uName,
      this.serviceName,
      this.serviceNameAr,
      this.doctId})
      : super(key: key);
  @override
  _ChooseTimeSlotsPageState createState() => _ChooseTimeSlotsPageState();
}

class _ChooseTimeSlotsPageState extends State<ChooseTimeSlotsPage> {
  bool _isLoading = false;
  bool _isEnableBtn = false;
  String _setTime = "";
  var _selectedDate;
  var _selectedDay = DateTime.now().weekday;
  List _closingDate = [];

  List _dayCode = [];
  List? _bookedTimeSlots;
  List<dynamic> _morningTimeSlotsList = [];
  List<dynamic> _afternoonTimeSlotsList = [];
  List<dynamic> _eveningTimeSlotsList = [];

  String _openingTimeHour = "";
  String _openingTimeMin = "";
  String _closingTimeHour = "";
  String _closingTimeMin = "";
  String _lunchOpeningTimeHour = "";
  String _lunchOpeningTimeMin = "";
  String _lunchClosingTimeHour = "";
  String _lunchClosingTimeMin = "";

  @override
  void initState() {
    super.initState();
    _getAndSetAllInitialData();
  }

  _getAndSetAllInitialData() async {
    setState(() {
      _isLoading = true;
    });

    _selectedDate = await _initializeDate(); //Initialize start time
    await _getAndSetbookedTimeSlots();
    await _getAndSetOpeningClosingTime();
    //await _setClosingDate();
    _getAndSetTimeSlots(
        _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);

    setState(() {
      _isLoading = false;
    });
  }

  _reCallMethods() async {
    setState(() {
      _isLoading = true;
    });
    await _getAndSetbookedTimeSlots();
    _getAndSetTimeSlots(
        _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _initializeDate() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.month}-${dateParse.day}-${dateParse.year}";

    return formattedDate;
  }

  Future<void> _getAndSetbookedTimeSlots() async {
    _bookedTimeSlots =
        await ReadData.fetchBookedTime(_selectedDate, widget.doctId);
  }

  Future<void> _getAndSetOpeningClosingTime() async {
    // var openingClosingTime = await ReadData.fetchOpeningClosingTime();
    // var res = await AppointmentTypeService.getTimingData(widget.serviceName);
    final res = await DrProfileService.getDataByDId(widget.doctId);

    //break the opening and closing time in to the hour and minute
    _openingTimeHour = (res[0].opt).substring(0, 2);
    _openingTimeMin = (res[0].opt).substring(3, 5);
    _closingTimeHour = (res[0].clt).substring(0, 2);
    _closingTimeMin = (res[0].clt).substring(3, 5);

    final ress =
        res[0].closingDate; //get all closed day for specific appointment
    if (ress != "" && ress != null) {
      final coledDatArr = (ress).split(',');
      for (var element in coledDatArr) {
        _dayCode.add(int.parse(element));
      }
    }

    if (res[0].lunchOpeningTime != "" && res[0].lunchClosingTime != "") {
      _lunchOpeningTimeHour = (res[0].lunchOpeningTime).substring(0, 2);
      _lunchOpeningTimeMin = (res[0].lunchOpeningTime).substring(3, 5);
      _lunchClosingTimeHour = (res[0].lunchClosingTime).substring(0, 2);
      _lunchClosingTimeMin = (res[0].lunchClosingTime).substring(3, 5);
    }
  }

  _getAndSetTimeSlots(String openingTimeHour, String openingTimeMin,
      String closingTimeHour, String closingTimeMin) {
    int serviceTime = widget.serviceTimeMin;

    List timeSlots = TimeCalculation.calculateTimeSlots(
        openingTimeHour,
        openingTimeMin,
        closingTimeHour,
        closingTimeMin,
        serviceTime); //calculate all the possible time slots between opening and closing time

    //  print("Service Time" + " " + "$serviceTime");
    // print("...................." + "$timeSlots");

    if (_bookedTimeSlots != null) {
      //if any booked time exists on the selected day
      timeSlots = TimeCalculation.reCalculateTimeSlots(
          timeSlots,
          _bookedTimeSlots!,
          _selectedDate,
          closingTimeHour,
          closingTimeMin,
          widget
              .serviceTimeMin); // Recalculate the time according to the booked time slots and date
    }
    // print("+++++++++++++++++++++++++ $timeSlots");

    _arrangeTimeSlots(
        timeSlots); //separate the time according to morning, afternoon and evening slots
  }

  _arrangeTimeSlots(List timeSlots) {
    _morningTimeSlotsList.clear();
    _afternoonTimeSlotsList.clear();
    _eveningTimeSlotsList.clear();

    timeSlots.forEach((element) {
      if (int.parse(element.substring(0, 2)) < 12)
        _morningTimeSlotsList.add(element);

      if (int.parse(element.substring(0, 2)) >= 12 &&
          int.parse(element.substring(0, 2)) < 17)
        _afternoonTimeSlotsList.add(element);

      if (int.parse(element.substring(0, 2)) >= 17 &&
          int.parse(element.substring(0, 2)) < 24)
        _eveningTimeSlotsList.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Select Time"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        title: "Update",
        isEnableBtn: _isEnableBtn,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: SingleChildScrollView(
                  // controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      _buildCalendar(),
                      Divider(),
                      _isLoading
                          ? LoadingIndicatorWidget()
                          : _closingDate.contains(_selectedDate) ||
                                  _dayCode.contains(_selectedDay)
                              ? Center(
                                  child: Text(
                                  "sorry! we don't take appointments in this day",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans-SemiBold',
                                    fontSize: 14,
                                  ),
                                ))
                              : Column(
                                  children: <Widget>[
                                    _morningTimeSlotsList.length == 0
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Morning Time Slot",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'OpenSans-SemiBold',
                                                  fontSize: 14,
                                                )),
                                          ),
                                    _morningTimeSlotsList.length == 0
                                        ? Container()
                                        : _slotsGridView(
                                            _morningTimeSlotsList,
                                            _bookedTimeSlots,
                                            widget.serviceTimeMin),
                                    _afternoonTimeSlotsList.length == 0
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Afternoon Time Slot",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'OpenSans-SemiBold',
                                                  fontSize: 14,
                                                )),
                                          ),
                                    _afternoonTimeSlotsList.length == 0
                                        ? Container()
                                        : _slotsGridView(
                                            _afternoonTimeSlotsList,
                                            _bookedTimeSlots,
                                            widget.serviceTimeMin),
                                    _eveningTimeSlotsList.length == 0
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Evening Time Slot",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'OpenSans-SemiBold',
                                                  fontSize: 14,
                                                )),
                                          ),
                                    _eveningTimeSlotsList.length == 0
                                        ? Container()
                                        : _slotsGridView(
                                            _eveningTimeSlotsList,
                                            _bookedTimeSlots,
                                            widget.serviceTimeMin),
                                  ],
                                )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update", _handleUpdate);
  }

  _handleUpdate() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final checkRes = await AppointmentService.getCheck(
        widget.doctId, _selectedDate, _setTime);
    if (checkRes.length == 0) {
      final res = await UpdateData.updateToRescheduled(
          widget.appointmentId,
          widget.appointmentDate,
          _setTime,
          _selectedDate,
          widget.serviceTimeMin,
          widget.doctId);
      if (res == "success") {
        List dateC = _selectedDate.toString().split("-");
        final appointmentModel = AppointmentModel(
            id: widget.appointmentId,
            appointmentStatus: "Rescheduled",
            appointmentDate: _selectedDate,
            appointmentTime: _setTime,
            dateC: dateC[2] + "-" + dateC[0] + "-" + dateC[1]);
        final isUpdated =
            await AppointmentService.updateDataResch(appointmentModel);
        if (isUpdated == "success") {
          _sendNotification();
          ToastMsg.showToastMsg("Successfully Updated");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/AppointmentListPage', ModalRoute.withName('/HomePage'));
        } else {
          ToastMsg.showToastMsg("Something went wrong");
        }
      } else {
        ToastMsg.showToastMsg("Something went wrong");
      }
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
      ToastMsg.showToastMsg(
          "already booked, please rebook with different time or date");
    }
  }

  Widget _buildCalendar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: primaryColor,
      selectedTextColor: Colors.white,
      onDateChange: (date) {
        // New date selected

        setState(() {
          final dateParse = DateTime.parse(date.toString());

          _selectedDate =
              "${dateParse.month}-${dateParse.day}-${dateParse.year}";
          _reCallMethods();
          _selectedDay = date.weekday;
        });
      },
    );
  }

  Widget _slotsGridView(timeSlotsList, bookedTimeSlot, serviceTimeMin) {
    //print("<><><><><><><><> $timeSlotsList");
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timeSlotsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 1, crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return _timeSlots(timeSlotsList[index], bookedTimeSlot, serviceTimeMin);
      },
    );
  }

  String _setTodayDateFormat() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('M-d-yyyy');
    String formatted = formatter.format(now);
    // if(formatted.substring(0,1)=="0") {
    //   formatted=formatted.substring(1,2)+formatter.format(now).substring(2);
    //
    // }
    return formatted;
  }

  Widget _timeSlots(String time, bookedTime, serviceTimeMin) {
    bool _isNoRemainingTime = false;

    final todayDate = _setTodayDateFormat();

    if (_selectedDate == todayDate) {
      // print(DateTime.now().month);
      if (int.parse(time.substring(0, 2)) < DateTime.now().hour) {
        //true the time is over

        _isNoRemainingTime = true;
      } else if (int.parse(time.substring(0, 2)) == DateTime.now().hour) {
        //false
        if (int.parse(time.substring(3, 5)) <= DateTime.now().minute) {
          _isNoRemainingTime = true;
        }
      }
    }
    if (_openingTimeHour != "" &&
        _closingTimeHour != "" &&
        _openingTimeMin != "" &&
        _closingTimeMin != "") {
      if (int.parse(time.substring(0, 2)) > int.parse(_lunchOpeningTimeHour) &&
          int.parse(time.substring(0, 2)) < int.parse(_lunchClosingTimeHour)) {
        //true the time is over

        _isNoRemainingTime = true;
      } else if (int.parse(time.substring(0, 2)) ==
          int.parse(_lunchOpeningTimeHour)) {
        if (int.parse(time.substring(3, 5)) >= int.parse(_lunchOpeningTimeMin))
          _isNoRemainingTime = true;
      } else if (int.parse(time.substring(0, 2)) ==
          int.parse(_lunchClosingTimeHour)) {
        if (int.parse(time.substring(3, 5)) <= int.parse(_lunchClosingTimeMin))
          _isNoRemainingTime = true;
      }
    }

    var bookedTimeSlots = [];

    if (bookedTime != null) {
      bookedTimeSlots = TimeCalculation.calculateBookedTime(
          time, bookedTime, serviceTimeMin); //get all disabled time
    }

    return GestureDetector(
      onTap: _isNoRemainingTime || bookedTimeSlots.contains(time)
          ? null
          : () {
              setState(() {
                _setTime == time ? _setTime = "" : _setTime = time;

                _setTime == "" ? _isEnableBtn = false : _isEnableBtn = true;
              });
            },
      child: Container(
        child: Card(
          color: time == _setTime
              ? primaryColor
              : _isNoRemainingTime || bookedTimeSlots.contains(time)
                  ? Colors.red
                  : Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                    color: time == _setTime ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendNotification() async {
    final notificationModel = NotificationModel(
        title: "Rescheduled",
        body:
            "your appointment has been rescheduled to date $_selectedDate time $_setTime",
        uId: widget.uId,
        routeTo: "/Appointmentstatus",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.uName);
    final msgAdded = await NotificationService.addData(notificationModel);

    if (msgAdded == "success") {
      final res = await UserService.getUserById(
          widget.uId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, "Rescheduled",
          "your appointment has been rescheduled to date $_selectedDate time $_setTime");
      await UpdateData.updateIsAnyNotification("usersList", widget.uId, true);
    }
  }

  // _setClosingDate() async {
  //   final res = await ReadData.fetchSettings();
  //   if (res != null) {
  //     setState(() {
  //       _closingDate = res["closingDate"];
  //     });
  //   }
  // }
}
