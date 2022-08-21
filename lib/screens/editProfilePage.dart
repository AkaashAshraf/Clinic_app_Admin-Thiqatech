import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/service/departmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool passValid = true;
  String _clinicOpeningTime = "10:00";
  String _clinicClosingTime = "20:00";
  String _lunchOpeningTime = "13:00";
  String _lunchClosingTime = "14:00";
  bool _isLoading = false;
  bool _stopBooking = false;
  String _imageUrl = "";
  List<Asset> _images = <Asset>[];
  String _id = "";
  List<String> deptList = ["Select Department"];
  List<String> deptIdList = [""];
  String _selectedDeptId = "";
  bool _isEnableBtn = true;
  TextEditingController _deptNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
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
  TextEditingController _launchOTCont = TextEditingController();
  TextEditingController _launchCTCont = TextEditingController();
  TextEditingController _serviceTime = TextEditingController();
  TextEditingController _appFeeCont = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _clinicName = TextEditingController();
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
    _fetchUserDetails(); //get and set all initial values
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descController.dispose();
    // _subTitleController.dispose();
    _whatsAppNoController.dispose();
    _primaryPhnController.dispose();
    _secondaryPhnController.dispose();
    _aboutUsController.dispose();
    _addressController.dispose();
    _deptNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          title: "Update",
          onPressed: _takeConfirmation,
          isEnableBtn: _isEnableBtn,
        ),
        appBar: IAppBars.commonAppBar(context, "Edit Profile"),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    if (_imageUrl == "")
                      if (_images.length == 0)
                        ECircularCameraIconWidget(onTap: _handleImagePicker)
                      else
                        ECircularImageWidget(
                          onPressed: _removeImage,
                          imageUrl: _imageUrl,
                          images: _images,
                        )
                    else
                      ECircularImageWidget(
                        onPressed: _removeImage,
                        imageUrl: _imageUrl,
                        images: _images,
                      ),
                    InputFields.readableInputField(
                        _clinicName, "Clinic Name", 1),
                    _inputField(
                        "First Name", "Enter first name", _firstNameController),
                    _inputField(
                        "Last Name", "Enter last name", _lastNameController),

                    _inputField(
                        "Subtitle", "Enter sub title", _subTitleController),
                    _inputField(
                        "Hospital Name", "Enter first name", _hNameController),
                    _ammountFiled(),
                    _serviceTimeInputField(),
                    textField("Opening Time: $_clinicOpeningTime"),
                    textField("Closing Time: $_clinicClosingTime"),
                    luchTimetextField("Lunch Opening Time: $_lunchOpeningTime"),
                    luchTimetextField("Lunch Closing Time: $_lunchClosingTime"),
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
                    // deptList.length > 0
                    //     ? _genderDropDown()
                    //     : Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
                    //     child: Text(
                    //       "Please add department",
                    //       style: TextStyle(color: Colors.red),
                    //     ),
                    //   ),
                    // ),
                    InputFields.readableInputField(
                        _deptNameController, "Department", 1),
                    _emailInputField(),
                    passInputField(_passController, "Password"),
                    confirmPassInputField(
                        _confirmPassController, "Confirm Password"),
                    _phnNumInputField(
                        _primaryPhnController, "Enter primary phone number"),
                    _phnNumInputField(_secondaryPhnController,
                        "Enter secondary phone number"),
                    _phnNumInputField(
                        _whatsAppNoController, "Enter what'sapp phone number"),
                    _descInputField(_addressController, "Address", null),
                    _descInputField(_descController, "Description", null),
                    _descInputField(_aboutUsController, "About us", null),
                    _stopBookingWidget(),
                  ],
                ),
              ));
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

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
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

  _takeConfirmation() {
    // if (_selectedDept == "Select Department") {
    //   ToastMsg.showToastMsg("please select department");
    // } else {
    print(_selectedDeptId);
    DialogBoxes.confirmationBox(context, "Update",
        "Are you sure you want to update profile details", _handleUpdate);
    // }
    //take a confirmation form the user
  }

  _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      //if all input fields are valid
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      if (_imageUrl == "" &&
          _images.length ==
              0) // if user not select any image and initial we have no any image
        _updateDetails(""); //update data without image
      else if (_imageUrl != "") //if initial we have image
        _updateDetails(_imageUrl); //update data with image
      else if (_imageUrl == "" &&
          _images.length >
              0) //if user select the image then first upload the image then update data in database
        _handleUploadImage(); //upload image in to database

    }
  }

  _updateDetails(imageDownloadUrl) async {
    // final cryptor = new PlatformStringCryptor();
    // final String key = await cryptor.generateRandomKey();
    // final String encrypted = await cryptor.encrypt(_passController.text, key);
    //print("<<<<<<<<<<<<<<<<<<<<<<<<<<<,$imageDownloadUrl");
    String newDays = "";
    if (_dayCode.length > 0) {
      for (int i = 0; i < _dayCode.length; i++) {
        if (i == 0)
          newDays = _dayCode[0].toString();
        else
          newDays = newDays + "," + _dayCode[i].toString();
      }
    }

    print("New Days $newDays");
    final drProfileModel = DrProfileModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      id: _id,
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
      deptId: _selectedDeptId,
      stopBooking: _stopBooking ? "true" : "false",
      clt: _clinicClosingTime,
      opt: _clinicOpeningTime,
      dayCode: newDays,
      serviceTime: _serviceTime.text,
      fee: _appFeeCont.text,
      pass: _passController.text,
    );

    final res = await DrProfileService.updateData(drProfileModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Email id is already registered");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  void _handleUploadImage() async {
    final res = await UploadImageService.uploadImages(_images[0]);
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
    else {
      await _updateDetails(res);
    }

    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _descInputField(controller, labelText, maxLine) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, maxLine);
  }

  // Widget _inputField(String labelText, String validatorText, controller) {
  //   return InputFields.commonInputField(controller, labelText, (item) {
  //     return item.length > 0 ? null : validatorText;
  //   }, TextInputType.text, 1);
  // }

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

  Widget _phnNumInputField(controller, labelText) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length == 13
          ? null
          : "Enter a 10 digit mobile number with country code";
    }, TextInputType.phone, 1);
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //1 is the number of images that user can pick
    //print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

    setState(() {
      _images = res;
    });
  }

  void _removeImage() {
    setState(() {
      _images.clear(); //clear array of the image
      _imageUrl = "";
    });
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final doctId = prefs.getString("doctId");
    final res = await DrProfileService.getDataByDId(
        doctId!); //fetch all details of the doctors
    // print(res["profileImageUrl"]);
    //set all the values in to text fields
    final res2 =
        await DepartmentService.getData(res[0].clinicId, res[0].cityId);
    for (var e in res2) {
      setState(() {
        deptList.add(e.name);
        deptIdList.add(e.id);
        if (e.id == res[0].deptId) {
          _selectedDeptId = e.id;
          _deptNameController.text = e.name;
        }
      });
    }

    print(generateMd5(res[0].pass));
    _emailController.text = res[0].email;
    _passController.text = res[0].pass;
    _confirmPassController.text = res[0].pass;
    _serviceTime.text = res[0].serviceTime;
    _lastNameController.text = res[0].lastName;
    _firstNameController.text = res[0].firstName;
    _clinicName.text = res[0].clinicName;
    _imageUrl = res[0].profileImageUrl;
    _descController.text = res[0].description;
    _subTitleController.text = res[0].subTitle;
    _whatsAppNoController.text = res[0].whatsAppNo;
    _primaryPhnController.text = res[0].pNo1;
    _secondaryPhnController.text = res[0].pNo2;
    _aboutUsController.text = res[0].aboutUs;
    _addressController.text = res[0].address;
    _id = res[0].id;
    _hNameController.text = res[0].hName;
    _launchCTCont.text = res[0].lunchClosingTime;
    _launchOTCont.text = res[0].lunchOpeningTime;
    _lunchClosingTime = res[0].lunchClosingTime;
    _lunchOpeningTime = res[0].lunchOpeningTime;
    _clinicClosingTime = res[0].clt;
    _clinicOpeningTime = res[0].opt;
    _appFeeCont.text = res[0].fee;
    if (res[0].stopBooking == "true")
      _stopBooking = true;
    else
      _stopBooking = false;
    if (res[0].dayCode != null && res[0].dayCode != "") {
      final day = res[0].dayCode.toString().split(",");
      for (var e in day) {
        _dayCode.add(int.parse(e));
      }
      if (_dayCode.contains(1))
        setState(() {
          _monCheckedValue = true;
        });

      if (_dayCode.contains(1))
        setState(() {
          _monCheckedValue = true;
        });

      if (_dayCode.contains(2))
        setState(() {
          _tueCheckedValue = true;
        });

      if (_dayCode.contains(3))
        setState(() {
          _wedCheckedValue = true;
        });

      if (_dayCode.contains(4))
        setState(() {
          _thuCheckedValue = true;
        });

      if (_dayCode.contains(5))
        setState(() {
          _friCheckedValue = true;
        });

      if (_dayCode.contains(6))
        setState(() {
          _satCheckedValue = true;
        });

      if (_dayCode.contains(7))
        setState(() {
          _sunCheckedValue = true;
        });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
