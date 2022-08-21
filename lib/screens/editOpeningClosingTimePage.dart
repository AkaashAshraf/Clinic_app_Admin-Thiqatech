import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditOpeningClosingTime extends StatefulWidget {
  @override
  _EditOpeningClosingTimeState createState() => _EditOpeningClosingTimeState();
}

class _EditOpeningClosingTimeState extends State<EditOpeningClosingTime> {
  String _clinicOpeningTime = "";
  String _clinicClosingTime = "";
  String _lunchOpeningTime = "";
  String _lunchClosingTime = "";
  bool isEnableBtn = true;
  bool _isLoading = false;
  List _dayCode = [];
  bool _monCheckedValue = false;
  bool _tueCheckedValue = false;
  bool _wedCheckedValue = false;
  bool _thuCheckedValue = false;
  bool _friCheckedValue = false;
  bool _satCheckedValue = false;
  bool _sunCheckedValue = false;
  @override
  void initState() {
    // TODO: implement initState
    _getAndSetInitialDataDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Clinic Time"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: isEnableBtn,
          onPressed: _handleUpdate,
          title: "Update",
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : ListView(
                children: [
                  _clinicOpeningTime == "" && _clinicClosingTime == ""
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            "Clinic Time",
                            style: TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 16,
                            ),
                          ),
                        ),
                  textField("Opening Time: $_clinicOpeningTime"),
                  textField("Closing Time: $_clinicClosingTime"),
                  SizedBox(height: 20),
                  _changeClinicTimeBtn(),
                  _lunchOpeningTime == "" && _lunchClosingTime == ""
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            "Lunch Time",
                            style: TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 16,
                            ),
                          ),
                        ),
                  textField("Opening Time: $_lunchOpeningTime"),
                  textField("Closing Time: $_lunchClosingTime"),
                  SizedBox(height: 20),
                  _changeLunchTimeBtn(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Select any days where you want to close booking in every week",
                          style: TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          )),
                    ),
                  ),
                  _buildDayCheckedBox("Monday", _monCheckedValue, 1),
                  _buildDayCheckedBox("Tuesday", _tueCheckedValue, 2),
                  _buildDayCheckedBox("Wednesday", _wedCheckedValue, 3),
                  _buildDayCheckedBox("Thursday", _thuCheckedValue, 4),
                  _buildDayCheckedBox("Friday", _friCheckedValue, 5),
                  _buildDayCheckedBox("Saturday", _satCheckedValue, 6),
                  _buildDayCheckedBox("Sunday", _sunCheckedValue, 7)
                ],
              ));
  }

  _handleUpdate() {
    DialogBoxes.confirmationBox(context, "Update",
        "Are you sure want to update the timing and day", _updateTimingDay);
  }

  _updateTimingDay() async {
    setState(() {
      _isLoading = true;
      isEnableBtn = false;
    });
    final res = await UpdateData.updateTiming(_clinicOpeningTime,
        _clinicClosingTime, _lunchOpeningTime, _lunchClosingTime, _dayCode);
    if (res == "success")
      ToastMsg.showToastMsg("Successfully Updated");
    else
      ToastMsg.showToastMsg("Something wents wrong");
    setState(() {
      _isLoading = false;
      isEnableBtn = true;
    });
  }

  Widget textField(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        readOnly: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            //labelText: title,
            hintText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  _changeLunchTimeBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: btnColor,
        ),
        onPressed: () async {
          TimeRange result = await showTimeRangePicker(
            start: TimeOfDay(
                hour: int.parse(_lunchOpeningTime.substring(0, 2)),
                minute: int.parse(_lunchOpeningTime.substring(3, 5))),
            end: TimeOfDay(
                hour: int.parse(_lunchClosingTime.substring(0, 2)),
                minute: int.parse(_lunchClosingTime.substring(3, 5))),
            strokeColor: primaryColor,
            handlerColor: primaryColor,
            selectedColor: primaryColor,
            context: context,
          );

          print("result>>>>>>>>>>>>>>>>>> " + result.toString());
          setState(() {
            if (result.toString().substring(17, 22) ==
                result.toString().substring(37, 42)) {
              ToastMsg.showToastMsg("please select different times");
            } else {
              _lunchOpeningTime = result.toString().substring(17, 22);
              _lunchClosingTime = result.toString().substring(37, 42);
              isEnableBtn = true;
            }
          });
        },
        child: Text(
          "Change Timing",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  _changeClinicTimeBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: btnColor,
        ),
        onPressed: () async {
          TimeRange result = await showTimeRangePicker(
            start: TimeOfDay(
                hour: int.parse(_clinicOpeningTime.substring(0, 2)),
                minute: int.parse(_clinicOpeningTime.substring(3, 5))),
            end: TimeOfDay(
                hour: int.parse(_clinicClosingTime.substring(0, 2)),
                minute: int.parse(_clinicClosingTime.substring(3, 5))),
            strokeColor: primaryColor,
            handlerColor: primaryColor,
            selectedColor: primaryColor,
            context: context,
          );

          print("result " + result.toString());
          setState(() {
            if (result.toString().substring(17, 22) ==
                result.toString().substring(37, 42)) {
              ToastMsg.showToastMsg("please select different times");
            } else {
              _clinicOpeningTime = result.toString().substring(17, 22);
              _clinicClosingTime = result.toString().substring(37, 42);
              isEnableBtn = true;
            }
          });

          print("op $_clinicOpeningTime clo $_clinicClosingTime");
        },
        child: Text(
          "Change Timing",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _getAndSetInitialDataDay() async {
    setState(() {
      _isLoading = true;
    });
    final res = await ReadData.fetchTiming();
    setState(() {
      _lunchOpeningTime = res["lunchOpeningTime"];
      _lunchClosingTime = res["lunchClosingTime"];
      _clinicOpeningTime = res["clinicOpeningTime"];
      _clinicClosingTime = res["clinicClosingTime"];
      _dayCode = res["dayCode"];
      _isLoading = false;
    });
    print(_dayCode);
    if (res["dayCode"].contains(1))
      setState(() {
        _monCheckedValue = true;
      });

    if (res["dayCode"].contains(1))
      setState(() {
        _monCheckedValue = true;
      });

    if (res["dayCode"].contains(2))
      setState(() {
        _tueCheckedValue = true;
      });

    if (res["dayCode"].contains(3))
      setState(() {
        _wedCheckedValue = true;
      });

    if (res["dayCode"].contains(4))
      setState(() {
        _thuCheckedValue = true;
      });

    if (res["dayCode"].contains(5))
      setState(() {
        _friCheckedValue = true;
      });

    if (res["dayCode"].contains(6))
      setState(() {
        _satCheckedValue = true;
      });

    if (res["dayCode"].contains(7))
      setState(() {
        _sunCheckedValue = true;
      });
  }

  _buildDayCheckedBox(String title, bool checkedValue, int dayCode) {
    return CheckboxListTile(
      activeColor: primaryColor,
      title: Text(title),
      value: checkedValue,
      onChanged: (newValue) {
        switch (dayCode) {
          case 1:
            {
              setState(() {
                _monCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case 2:
            {
              setState(() {
                _tueCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case 3:
            {
              setState(() {
                _wedCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case 4:
            {
              setState(() {
                _thuCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case 5:
            {
              setState(() {
                _friCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case 6:
            {
              setState(() {
                _satCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
              });
            }
            break;
          case 7:
            {
              setState(() {
                _sunCheckedValue = newValue!;
                if (newValue)
                  _dayCode.add(dayCode);
                else
                  _dayCode.remove(dayCode);
                print(_dayCode);
              });
            }
        }
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }
}
