import 'package:demoadmin/model/clinicModel.dart';
import 'package:demoadmin/service/clinicService.dart';

import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class EditClinicPage extends StatefulWidget {
  final cityId;
  final dataDetails;
  const EditClinicPage({Key? key, this.dataDetails, this.cityId})
      : super(key: key);

  @override
  _EditClinicPageState createState() => _EditClinicPageState();
}

class _EditClinicPageState extends State<EditClinicPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Asset> _images = <Asset>[];
  TextEditingController _clinicNameController = new TextEditingController();
  TextEditingController _gLocationUrlController = new TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";
  String checkValue = "1";

  @override
  void initState() {
    // TODO: implement initState
    //initialize all textController values
    _clinicNameController.text = widget.dataDetails.title;
    _gLocationUrlController.text = widget.dataDetails.location;
    checkValue = widget.dataDetails.number_reveal;
    //initialize image url
    _imageUrl = widget.dataDetails.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _clinicNameController..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Clinic"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
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
                          onPressed: _removeImage,
                          images: _images,
                          imageUrl: _imageUrl,
                        )
                    else
                      ECircularImageWidget(
                        onPressed: _removeImage,
                        images: _images,
                        imageUrl: _imageUrl,
                      ),
                    _serviceNameInputField(),
                    _gLocationInputField(),
                    _stopBookingWidget(),
                    _deleteServiceBtn()
                  ],
                ),
              ),
            ),
    );
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Update",
          "Are you sure want to update",
          _handleUpdate); //take confirmation form user
    }
  }

  Widget _deleteServiceBtn() {
    return DeleteButtonWidget(
      onPressed: () {
        DialogBoxes.confirmationBox(
            context,
            "Delete",
            "Are you sure want to delete",
            _handleDeleteService); //take confirmation from user
      },
      title: "Delete",
    );
  }

  Widget _stopBookingWidget() {
    return ListTile(
      title: Text("Doctors Contact Info"),
      subtitle: checkValue == "1"
          ? Text("turn off to hide Doctors Contact Info")
          : Text("turn on to show Doctors Contact Info"),
      trailing: IconButton(
        icon: checkValue == "1"
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
            if (checkValue == "1")
              checkValue = "0";
            else
              checkValue = "1";
          });
        },
      ),
    );
  }

  _handleDeleteService() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await ClinicService.deleteData(widget.dataDetails.id);
    // print(res);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/CityListPage', ModalRoute.withName('/'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //1 is number of images user can pick
    setState(() {
      _images = res;
    });
  }

  _handleUpdate() {
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
    else if (_imageUrl == "" && _images.length > 0) _handleUploadImage();
    //if user select the image then first upload the image then update data in database
    //  _uploadImg(); //upload image in to database
  }

  void _removeImage() {
    setState(() {
      _images.clear(); //clear array
      _imageUrl = "";
    });
  }

  _updateDetails(imageDownloadUrl) async {
    ClinicModel clinicModel = ClinicModel(
        title: _clinicNameController.text,
        imageUrl: imageDownloadUrl,
        id: widget.dataDetails.id,
        location: _gLocationUrlController.text,
        cityId: widget.cityId,
        number_reveal: checkValue);
    final res = await ClinicService.updateData(clinicModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Clinic Name is already exists");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/CityListPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _gLocationInputField() {
    return InputFields.commonInputField(
        _gLocationUrlController, "Google Mao Location*", (item) {
      return item.length > 0 ? null : "Enter google location url";
    }, TextInputType.text, 1);
  }

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_clinicNameController, "Title*",
        (item) {
      return item.length > 0 ? null : "Enter clinic name";
    }, TextInputType.text, 1);
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
}
