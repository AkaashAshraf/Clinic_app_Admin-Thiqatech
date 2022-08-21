import 'package:demoadmin/model/clinicModel.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';

class AddClinicPage extends StatefulWidget {
  final cityId;
  final cityName;
  AddClinicPage({this.cityId, this.cityName});
  @override
  _AddClinicPageState createState() => _AddClinicPageState();
}

class _AddClinicPageState extends State<AddClinicPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String checkValue = "1";
  List<Asset> _images = <Asset>[];
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add City"),
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
                    _serviceNameInputField(),
                    _locationInputField(),
                    _stopBookingWidget(),
                  ],
                ),
              ),
            ),
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

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_nameController, "Title*", (item) {
      return item.length > 0 ? null : "Enter clinic name";
    }, TextInputType.text, 1);
  }

  Widget _locationInputField() {
    return InputFields.commonInputField(
        _locationController, "Google Mao Location*", (item) {
      return item.length > 0 ? null : "Enter google location";
    }, TextInputType.text, 1);
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Add New",
          "Are you sure want to add new clinic",
          _handleUpload); //take a confirmation from the user
    }
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //pick image with one limit
    setState(() {
      _images = res;
    });
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

  void _removeImage() {
    setState(() {
      _images.clear(); //clean array
    });
  }

  _uploadData(imageDownloadUrl) async {
    print(widget.cityName);
    ClinicModel clinicModel = ClinicModel(
        title: _nameController.text,
        imageUrl: imageDownloadUrl,
        cityId: widget.cityId,
        location: _locationController.text,
        locationName: widget.cityName,
        number_reveal: checkValue);
    final res = await ClinicService.addData(clinicModel);
    print(res); //upload data with all required details
    if (res == "already exists") {
      ToastMsg.showToastMsg("Clinic Name is already exists");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Uploaded");
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/CityListPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg('Something went wrong');
    }
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
