import 'dart:developer';

import 'package:demoadmin/model/appointmentTypeModel.dart';
import 'package:demoadmin/service/appointmentTypeService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditAppointmentTypes extends StatefulWidget {
  final appointmentTypesDetails;
  final disableStartTime;
  final disableEndTime;

  const EditAppointmentTypes(
      {Key? key,
      this.appointmentTypesDetails,
      this.disableStartTime,
      this.disableEndTime})
      : super(key: key);
  @override
  _EditAppointmentTypesState createState() => _EditAppointmentTypesState();
}

class _EditAppointmentTypesState extends State<EditAppointmentTypes> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Asset> _images = <Asset>[];
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _titleArController = new TextEditingController();
  TextEditingController _timeTakesController = new TextEditingController();
  TextEditingController _subTitleController = new TextEditingController();
  TextEditingController _subTitleArController = new TextEditingController();
  TextEditingController _openingTimeController = new TextEditingController();
  TextEditingController _closingTimeController = new TextEditingController();
  TextEditingController _chargesController = new TextEditingController();
  int? disableStartTimeHour;
  int? disableEndTimeHour;
  int? disableStartTimeMin;
  int? disableEndTimeMin;

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";
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
    //initialize all text field value
    _titleController.text = widget.appointmentTypesDetails.titleEn;
    _titleArController.text = widget.appointmentTypesDetails.titleAr;
    _timeTakesController.text =
        widget.appointmentTypesDetails.forTimeMin.toString();
    _imageUrl = widget.appointmentTypesDetails.imageUrl;
    _subTitleController.text = widget.appointmentTypesDetails.subTitleEn;
    _subTitleArController.text = widget.appointmentTypesDetails.subTitleAr;
    _chargesController.text = widget.appointmentTypesDetails.charges;
    _openingTimeController.text = widget.appointmentTypesDetails.openingTime;
    _closingTimeController.text = widget.appointmentTypesDetails.closingTime;

    setState(() {
      disableStartTimeHour =
          int.parse((widget.disableStartTime).substring(0, 2));
      disableEndTimeHour = int.parse((widget.disableEndTime).substring(0, 2));
      disableStartTimeMin =
          int.parse((widget.disableStartTime).substring(3, 5));
      disableEndTimeMin = int.parse((widget.disableEndTime).substring(3, 5));
    });
    _getAndSetInitialDataDay();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _titleArController.dispose();
    _timeTakesController.dispose();
    _subTitleController.dispose();
    _subTitleArController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Types"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
        title: "Update",
      ),
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    if (_imageUrl == "")
                      if (_images.length == 0)
                        ECircularCameraIconWidget(
                          onTap: _handleImagePicker,
                        )
                      else
                        ECircularImageWidget(
                          images: _images,
                          onPressed: _removeImage,
                          imageUrl: _imageUrl,
                        )
                    else
                      ECircularImageWidget(
                        images: _images,
                        onPressed: _removeImage,
                        imageUrl: _imageUrl,
                      ),
                    _titleInputField(),
                    _titleArInputField(),
                    _subTitleInputField(),
                    _subTitleArInputField(),
                    _chargesInputField(),
                    _timeTakesInputField(),
                    _timingInputField("Opening Time", _openingTimeController),
                    _timingInputField("Closing Time", _closingTimeController),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Text(
                            "Select any days where you want to close booking in every week",
                            style: TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 14,
                            )),
                      ),
                    ),
                    _buildDayCheckedBox("Monday", _monCheckedValue, "1"),
                    _buildDayCheckedBox("Tuesday", _tueCheckedValue, "2"),
                    _buildDayCheckedBox("Wednesday", _wedCheckedValue, "3"),
                    _buildDayCheckedBox("Thursday", _thuCheckedValue, "4"),
                    _buildDayCheckedBox("Friday", _friCheckedValue, "5"),
                    _buildDayCheckedBox("Saturday", _satCheckedValue, "6"),
                    _buildDayCheckedBox("Sunday", _sunCheckedValue, "7"),
                    _deleteAppointmentTypeBtn()
                  ],
                ),
              ),
            ),
    );
  }

  void _getAndSetInitialDataDay() async {
    final res = widget.appointmentTypesDetails;
    if (res.day != "" && res.day != null) {
      final closedDayArr = (res.day).split(',');
      for (var element in closedDayArr) {
        _dayCode.add(element);
      }

      if (_dayCode.contains("1"))
        setState(() {
          _monCheckedValue = true;
        });

      if (_dayCode.contains("2"))
        setState(() {
          _tueCheckedValue = true;
        });

      if (_dayCode.contains("3"))
        setState(() {
          _wedCheckedValue = true;
        });

      if (_dayCode.contains("4"))
        setState(() {
          _thuCheckedValue = true;
        });

      if (_dayCode.contains("5"))
        setState(() {
          _friCheckedValue = true;
        });

      if (_dayCode.contains("6"))
        setState(() {
          _satCheckedValue = true;
        });

      if (_dayCode.contains("7"))
        setState(() {
          _sunCheckedValue = true;
        });
    }
  }

  Widget _deleteAppointmentTypeBtn() {
    return DeleteButtonWidget(
        title: "Delete",
        onPressed: () {
          DialogBoxes.confirmationBox(context, "delete",
              "Are you sure want to delete", _handleDeleteService);
        });
  }

  _handleDeleteService() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await AppointmentTypeService.deleteData(
        widget.appointmentTypesDetails.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentTypesPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(_images, mounted, 1);
    // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

    setState(() {
      _images = res;
    });
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Update",
        "Are you sure want to update",
        _handleUpdate); //take confirmation form user
  }

  _handleUpdate() {
    if (_formKey.currentState!.validate()) {
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

      // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
    }
  }

  void _removeImage() {
    setState(() {
      _images.clear();
      _imageUrl = "";
    });
  }

  _updateDetails(imageDownloadUrl) async {
    log(_chargesController.text +'  _>'+ widget.appointmentTypesDetails.id);
    String day = "";
    if (_dayCode.length > 0) {
      for (int i = 0; i < _dayCode.length; i++) {
        if (i == 0) {
          day = _dayCode[i];
      } else {
          day = day + "," + _dayCode[i];
        }
      }
    }


    final appointmentTypeModel = AppointmentTypeModel(
        forTimeMin: _timeTakesController.text,
        titleEn: _titleController.text,
        titleAr: _titleArController.text,
        imageUrl: imageDownloadUrl,
        id: widget.appointmentTypesDetails.id,
        subTitleEn: _subTitleController.text,
        subTitleAr: _subTitleArController.text,
        openingTime: _openingTimeController.text,
        closingTime: _closingTimeController.text,
        day: day,
        charges: _chargesController.text
        );
    final res = await AppointmentTypeService.updateData(appointmentTypeModel);

    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentTypesPage', ModalRoute.withName('/HomePage'));
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
    else
      await _updateDetails(res);

    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _subTitleInputField() {
    return InputFields.commonInputField(
        _subTitleController, "Appointment Subtitle En", (item) {
      return item.length > 0 ? null : "Enter Appointment Subtitle in English";
    }, TextInputType.text, 1);
  }

    Widget _subTitleArInputField() {
    return InputFields.commonInputField(
        _subTitleArController, "Appointment Subtitle Ar", (item) {
      return item.length > 0 ? null : "Enter Appointment Subtitle in Arabic";
    }, TextInputType.text, 1);
  }

  Widget _chargesInputField() {
    return InputFields.commonInputField(
        _chargesController, "Appointment Charges", (item) {
      return item.length > 0 ? null : "Enter Appointment Charges";
    }, TextInputType.number, 1);
  }

  Widget _titleInputField() {
    return InputFields.commonInputField(_titleController, "Appointment Name",
        (item) {
      return item.length > 0 ? null : "Enter Appointment Name";
    }, TextInputType.text, 1);
  }

   Widget _titleArInputField() {
    return InputFields.commonInputField(_titleArController, "Appointment Name Ar",
        (item) {
      return item.length > 0 ? null : "Enter Appointment Name in Arabic";
    }, TextInputType.text, 1);
  }

  Widget _timeTakesInputField() {
    return InputFields.commonInputField(
        _timeTakesController, "How Much Time will take (in minute)", (item) {
      if (item.length == 0)
        return "Enter Time";
      else if (item.length > 0 && item == "0")
        return "Enter valid time";
      else
        return null;
    }, TextInputType.number, 1);
  }

  Widget _timingInputField(title, controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        onTap: _timePicker,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            labelText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  void _timePicker() async {
    TimeRange result = await showTimeRangePicker(
      disabledTime: TimeRange(
          startTime:
              TimeOfDay(hour: disableEndTimeHour!, minute: disableEndTimeMin!),
          endTime: TimeOfDay(
              hour: disableStartTimeHour!, minute: disableStartTimeMin!)),
      start: TimeOfDay(
          hour: int.parse(_openingTimeController.text.substring(0, 2)),
          minute: int.parse(_openingTimeController.text.substring(3, 5))),
      end: TimeOfDay(
          hour: int.parse(_closingTimeController.text.substring(0, 2)),
          minute: int.parse(_closingTimeController.text.substring(3, 5))),
      strokeColor: primaryColor,
      handlerColor: primaryColor,
      selectedColor: primaryColor,
      context: context,
    );

    setState(() {
      if (result.toString().substring(17, 22) ==
          result.toString().substring(37, 42)) {
        ToastMsg.showToastMsg("please select different times");
      } else {
        _openingTimeController.text = result.toString().substring(17, 22);
        _closingTimeController.text = result.toString().substring(37, 42);
      }
    });
  }

  _buildDayCheckedBox(String title, bool checkedValue, String dayCode) {
    return CheckboxListTile(
      activeColor: primaryColor,
      title: Text(title),
      value: checkedValue,
      onChanged: (newValue) {
        switch (dayCode) {
          case "1":
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
          case "2":
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
          case "3":
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
          case "4":
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
          case "5":
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
          case "6":
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
          case "7":
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
