import 'package:demoadmin/model/serviceModel.dart';
import 'package:demoadmin/service/serviceService.dart';
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

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Asset> _images = <Asset>[];
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _subTitleInputController = new TextEditingController();
  TextEditingController _descInputController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _subTitleInputController.dispose();
    _descInputController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Service"),
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
                    _subTitleInputField(),
                    _urlInputField(),
                    _descInputField(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_nameController, "Title*", (item) {
      return item.length > 0 ? null : "Enter service name";
    }, TextInputType.text, 1);
  }

  Widget _urlInputField() {
    return InputFields.commonInputField(_urlController, "Url", (item) {
      return null;
    }, TextInputType.text, null);
  }

  Widget _subTitleInputField() {
    return InputFields.commonInputField(_subTitleInputController, "Sub Title*",
        (item) {
      return item.length > 0 ? null : "Enter Subtitle";
    }, TextInputType.text, 1);
  }

  Widget _descInputField() {
    return InputFields.commonInputField(_descInputController, "Description",
        (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, null);
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      if (_urlController.text.length > 0) {
        if (Uri.parse(_urlController.text).isAbsolute)
          DialogBoxes.confirmationBox(context, "Add Service",
              "Are you sure want to add new service", _handleUpload);
        else
          ToastMsg.showToastMsg("Please enter valid url");
      } else {
        DialogBoxes.confirmationBox(context, "Add Service",
            "Are you sure want to add new service", _handleUpload);
      }
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
    final serviceModel = ServiceModel(
        title: _nameController.text,
        subTitle: _subTitleInputController.text,
        imageUrl: imageDownloadUrl,
        desc: _descInputController.text,
        url: _urlController.text);
    final res = await ServiceService.addData(
        serviceModel); //upload data with all required details
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Uploaded");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/ServicesPage', ModalRoute.withName('/HomePage'));
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
