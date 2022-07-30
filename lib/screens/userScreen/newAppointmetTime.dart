import 'package:demoadmin/service/dateAndTimeCalculation.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class NewAppointmentTimePage extends StatefulWidget {
  final openingTime;
  final closingTime;
  final serviceName;
  final serviceTimeMin;
  final closedDay;
  final userDetails;

  const NewAppointmentTimePage(
      {Key? key,
      this.openingTime,
      this.closingTime,
      this.serviceName,
      this.serviceTimeMin,
      this.closedDay,
      this.userDetails})
      : super(key: key);

  @override
  _NewAppointmentTimePageState createState() => _NewAppointmentTimePageState();
}

class _NewAppointmentTimePageState extends State<NewAppointmentTimePage> {
  bool _isLoading = false;
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
    await _setClosingDate();
    _getAndsetTimeSlots(
        _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);

    setState(() {
      _isLoading = false;
    });
  }

  _reCallMethodes() async {
    setState(() {
      _isLoading = true;
    });
    await _getAndSetbookedTimeSlots();
    _getAndsetTimeSlots(
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
    _bookedTimeSlots = await ReadData.fetchBookedTime(_selectedDate, "");
    // await ReadData().fetchBookedTime(GlobalVariables.selectedClinicId);
  }

  Future<void> _getAndSetOpeningClosingTime() async {
    var openingClosingTime = await ReadData.fetchOpeningClosingTime();
    //break the opening and closing time in to the hour and minute
    _openingTimeHour = (widget.openingTime).substring(0, 2);
    _openingTimeMin = (widget.openingTime).substring(3, 5);
    _closingTimeHour = (widget.closingTime).substring(0, 2);
    _closingTimeMin = (widget.closingTime).substring(3, 5);

    //  _dayCode = openingClosingTime["dayCode"]; //get and set clinic closing days
    //   final res=widget.closedDay; //get all closed day for specific appointment
    //   if(res!=""&&res!=null){
    //     final coledDatArr=(res).split(',');
    //     for(var element in coledDatArr){
    //       _dayCode.add(int.parse(element));
    //     }
    //   }
    if (openingClosingTime["lunchOpeningTime"] != "" &&
        openingClosingTime["lunchClosingTime"] != "") {
      _lunchOpeningTimeHour =
          (openingClosingTime["lunchOpeningTime"]).substring(0, 2);
      _lunchOpeningTimeMin =
          (openingClosingTime["lunchOpeningTime"]).substring(3, 5);
      _lunchClosingTimeHour =
          (openingClosingTime["lunchClosingTime"]).substring(0, 2);
      _lunchClosingTimeMin =
          (openingClosingTime["lunchClosingTime"]).substring(3, 5);
    }
  }

  _getAndsetTimeSlots(String openingTimeHour, String openingTimeMin,
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
      appBar: IAppBars.commonAppBar(context, "Choose Time"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: _setTime == "" ? false : true,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RegisterPatient(
          //       userDetails: widget.userDetails,
          //       serviceName: widget.serviceName,
          //       serviceTimeMin: widget.serviceTimeMin,
          //       setTime: _setTime,
          //       selectedDate: _selectedDate,
          //     ),
          //   ),
          // );
        },
        title: "Next",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10, right: 10),
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
                                    "Sorry! we can't take appointments in this day",
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
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
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
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
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
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
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
      ),
    );
  }

  Widget _buildCalendar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: btnColor,
      selectedTextColor: Colors.white,
      daysCount: 7,
      onDateChange: (date) {
        // New date selected
        setState(() {
          final dateParse = DateTime.parse(date.toString());

          _selectedDate =
              "${dateParse.month}-${dateParse.day}-${dateParse.year}";
          _selectedDay = date.weekday;
          _reCallMethodes();
        });
      },
    );
  }

  Widget _slotsGridView(timeSlotsList, bookedTimeSlot, serviceTimeMin) {
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

  String _setTodayDateFormate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('M-d-yyyy');
    String formatted = formatter.format(now);
    // if(formatted.substring(0,1)=="0") {
    //   formatted=formatted.substring(1,2)+formatter.format(now).substring(2);
    // }
    return formatted;
  }

  Widget _timeSlots(String time, bookedTime, serviceTimeMin) {
    bool _isNoRemainingTime = false;

    //print("dddddddddddddddddd ");
    final todayDate = _setTodayDateFormate();
    // print("tooooooooodddddddddddd $todayDate");

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
    // print(time);
    // print(_isNoRemainingTime);
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
              });
            },
      child: Container(
        child: Card(
          color: time == _setTime
              ? btnColor
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
                    color: time == _setTime ? Colors.white : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setClosingDate() async {
    final res = await ReadData.fetchSettings();
    if (res != null) {
      setState(() {
        _closingDate = res["closingDate"];
      });
    }
  }
}
