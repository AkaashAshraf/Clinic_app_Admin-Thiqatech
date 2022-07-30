import 'dart:convert';
import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/service/addData.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddDoctorsPage extends StatefulWidget {
  final clinicId;
  final deptID;
  final cityId;
  AddDoctorsPage({this.cityId, this.clinicId, this.deptID});
  @override
  _AddDoctorsPageState createState() => _AddDoctorsPageState();
}

class _AddDoctorsPageState extends State<AddDoctorsPage> {
  List<Asset> _images = <Asset>[];
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _clinicOpeningTime = "10:00";
  String _clinicClosingTime = "20:00";
  String _lunchOpeningTime = "13:00";
  String _lunchClosingTime = "14:00";
  bool _isLoading = false;
  bool _stopBooking = false;
  bool _isEnableBtn = true;
  bool passValid = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _whatsAppNoController = TextEditingController();
  TextEditingController _primaryPhnController = TextEditingController();
  TextEditingController _secondaryPhnController = TextEditingController();
  TextEditingController _aboutUsController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _hNameController = TextEditingController();
  TextEditingController _serviceTime = TextEditingController();
  TextEditingController _appFeeCont = TextEditingController();

  List _dayCode = [];
  bool _monCheckedValue = false;
  bool _tueCheckedValue = false;
  bool _wedCheckedValue = false;
  bool _thuCheckedValue = false;
  bool _friCheckedValue = false;
  bool _satCheckedValue = false;
  bool _sunCheckedValue = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _appFeeCont.dispose();
    _passController.dispose();
    _serviceTime.dispose();
    _appFeeCont.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descController.dispose();
    _subTitleController.dispose();
    _whatsAppNoController.dispose();
    _primaryPhnController.dispose();
    _secondaryPhnController.dispose();
    _aboutUsController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Add New"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Add",
          onPressed: _takeConfirmation,
          isEnableBtn: _isEnableBtn,
        ),
        body: _isLoading
            ? Center(child: LoadingIndicatorWidget())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      _images.length == 0
                          ? CircularCameraIconWidget(onTap: _handleImagePicker)
                          : CircularImageWidget(
                              images: _images,
                              onPressed: _removeImage,
                            ),
                      _inputField("First Name", "Enter first name",
                          _firstNameController),
                      _inputField(
                          "Last Name", "Enter last name", _lastNameController),
                      _inputField(
                          "Subtitle", "Enter sub title", _subTitleController),
                      _inputField("Hospital Name", "Enter first name",
                          _hNameController),
                      _ammountFiled(),
                      _serviceTimeInputField(),

                      textField("Opening Time: $_clinicOpeningTime"),
                      textField("Closing Time: $_clinicClosingTime"),
                      luchTimetextField(
                          "Lunch Opening Time: $_lunchOpeningTime"),
                      luchTimetextField(
                          "Lunch Closing Time: $_lunchClosingTime"),
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
                      _buildDayCheckedBox("Sunday", _sunCheckedValue, 7),
                      // _inputField(
                      //     "Launch opening time (HH:MM)", "Enter last name", _launchOTCont),
                      // _inputField(
                      //     "Launch closing time (HH:MM)", "Enter sub title", _launchCTCont),

                      _emailInputField(),
                      passInputField(_passController, "Password"),
                      confirmPassInputField(
                          _confirmPassController, "Confirm Password"),

                      _phnNumInputField(
                          _primaryPhnController, "Enter primary phone number"),
                      _phnNumInputField(_secondaryPhnController,
                          "Enter secondary phone number"),
                      _phnNumInputField(_whatsAppNoController,
                          "Enter what'sapp phone number"),
                      _descInputField(_addressController, "Address", null),
                      _descInputField(_descController, "Description", null),
                      _descInputField(_aboutUsController, "About us", null),
                      _stopBookingWidget(),
                    ],
                  ),
                ),
              ));
  }

  Widget passInputField(controller, labelText) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            TextFormField(
              obscureText: true,
              controller: controller,
              validator: (item) {
                if (item!.length > 7 && item.length < 20) {
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  bool checkValid = regExp.hasMatch(item);
                  if (checkValid)
                    setState(() {
                      passValid = true;
                    });
                  else
                    setState(() {
                      passValid = false;
                    });

                  return checkValid ? null : "Enter a valid password";
                } else {
                  return "length should be at least 8";
                }
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )),
            ),
            !passValid ? SizedBox(height: 8) : Container(),
            !passValid
                ? Text(
                    "Password length should be greater then 8 and Minimum 1 Upper case, 1 lowercase,1 Numeric Number",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  )
                : Container(),
          ],
        ));
  }

  Widget confirmPassInputField(controller, labelText) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            TextFormField(
              obscureText: true,
              controller: controller,
              validator: (item) {
                if (item!.length > 7 && item.length < 20) {
                  if (item == _passController.text)
                    return null;
                  else
                    return "Confirm password must be same with password";
                } else {
                  return "Enter confirm password";
                }
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )),
            ),
          ],
        ));
  }

  Widget _ammountFiled() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: null,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _appFeeCont,
        validator: (item) {
          if (item!.length == 0)
            return "Enter price";
          else if (item.length > 5)
            return "only enter a 5 digit price";
          else
            return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Enter price INR",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  Widget textField(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        onTap: () async {
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
              //_isEnableBtn = true;
            }
          });

          print("op $_clinicOpeningTime clo $_clinicClosingTime");
        },
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

  Widget luchTimetextField(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        onTap: () async {
          // print("kkkkkkkkkkkkkkkkkkkkkk");
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

          //  print("result>>>>>>>>>>>>>>>>>> " + result.toString());

          setState(() {
            if (result.toString().substring(17, 22) ==
                result.toString().substring(37, 42)) {
              ToastMsg.showToastMsg("please select different times");
            } else {
              _lunchOpeningTime = result.toString().substring(17, 22);
              _lunchClosingTime = result.toString().substring(37, 42);
              //    isEnableBtn = true;
            }
          });
        },
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

  _serviceTimeInputField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        maxLines: 1,
        controller: _serviceTime,
        validator: (item) {
          if (item!.length > 0) {
            if (item.length < 3)
              return null;
            else
              return "Enter valid interval";
          } else
            return "Enter time interval";
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Time interval in (MIN)",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
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

  Widget _descInputField(controller, labelText, maxLine) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, maxLine);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  void _removeImage() {
    setState(() {
      _images.clear(); //clean array
    });
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //pick image with one limit
    setState(() {
      _images = res;
    });
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
      Pattern pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = new RegExp(pattern.toString());
      if (!regex.hasMatch(item) || item == null)
        return 'Enter a valid email address';
      else
        return null;
    }, TextInputType.emailAddress, 1);
  }

  Widget _stopBookingWidget() {
    return ListTile(
      title: Text("online booking"),
      subtitle: _stopBooking
          ? Text("turn off to start online booking")
          : Text("turn on to stop online booking"),
      trailing: IconButton(
        icon: _stopBooking
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: () {
          setState(() {
            _stopBooking = !_stopBooking;
          });
        },
      ),
    );
  }

  Widget _phnNumInputField(controller, labelText) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length == 13
          ? null
          : "Enter a 10 digit mobile number with country code";
    }, TextInputType.phone, 1);
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Add Doctor",
          "Are you sure want to add new Doctor",
          _handleUpload); //take a confirmation from the user

    }
  }

  _handleUpload() {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    _images.length > 0
        ? _uploadImg()
        : _uploadData(""); //check user selected image or not
  }

  _uploadData(imageDownloadUrl) async {
    String newDays = "";
    if (_dayCode.length > 0) {
      for (int i = 0; i < _dayCode.length; i++) {
        if (i == 0)
          newDays = _dayCode[0].toString();
        else
          newDays = newDays + "," + _dayCode[i].toString();
      }
    }
    final drProfileModel = DrProfileModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        description: _descController.text,
        subTitle: _subTitleController.text,
        email: _emailController.text,
        aboutUs: _aboutUsController.text,
        address: _addressController.text,
        pNo1: _primaryPhnController.text,
        pNo2: _secondaryPhnController.text,
        profileImageUrl: imageDownloadUrl,
        whatsAppNo: _whatsAppNoController.text,
        hName: _hNameController.text,
        lunchClosingTime: _lunchClosingTime,
        lunchOpeningTime: _lunchOpeningTime,
        deptId: widget.deptID,
        stopBooking: _stopBooking ? "true" : "false",
        clt: _clinicClosingTime,
        opt: _clinicOpeningTime,
        dayCode: newDays,
        serviceTime: _serviceTime.text,
        fee: _appFeeCont.text,
        cityId: widget.cityId,
        clinicId: widget.clinicId,
        pass: _passController.text);

    final res = await DrProfileService.addData(
        drProfileModel); //upload data with all required details
    print(res);
    var jsonData = await json.decode(res);
    if (jsonData['status'] == "true") {
      if (jsonData['msg'] == "already exists") {
        ToastMsg.showToastMsg("Email id is already registered");
      } else if (jsonData['msg'] == "added") {
        await AddData.addNotiDetails(jsonData['id'].toString());
        ToastMsg.showToastMsg("Successfully Uploaded");
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else
      ToastMsg.showToastMsg('Something went wrong');
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _uploadImg() async {
    final res = await UploadImageService.uploadImages(
        _images[0]); //upload image in the database
    //all this error we have sated in the the php files
    if (res == "0")
      ToastMsg.showToastMsg(
          "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    else if (res == "1")
      ToastMsg.showToastMsg("Image size must be less the 1MB");
    else if (res == "2")
      ToastMsg.showToastMsg(
          "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    else if (res == "3" || res == "error")
      ToastMsg.showToastMsg("Something went wrong");
    else if (res == "")
      ToastMsg.showToastMsg("Something went wrong");
    else
      await _uploadData(res);

    setState(() {
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });
    });
  }
}
