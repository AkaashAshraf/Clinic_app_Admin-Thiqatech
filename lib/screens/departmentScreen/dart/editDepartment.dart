import 'package:demoadmin/model/departmentModel.dart';
import 'package:demoadmin/service/departmentService.dart';
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

class EditDepartmentPage extends StatefulWidget {
  final clinicId;
  final cityId;
  final dataDetails;
  const EditDepartmentPage(
      {Key? key, this.dataDetails, this.clinicId, this.cityId})
      : super(key: key);

  @override
  _EditDepartmentPageState createState() => _EditDepartmentPageState();
}

class _EditDepartmentPageState extends State<EditDepartmentPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Asset> _images = <Asset>[];
  TextEditingController _deptNameController = new TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    //initialize all textController values
    _deptNameController.text = widget.dataDetails.name;
    //initialize image url
    _imageUrl = widget.dataDetails.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _deptNameController..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Department"),
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

  _handleDeleteService() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await DepartmentService.deleteData(widget.dataDetails.id);

    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.pop(context);
      Navigator.pop(context);
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
    DepartmentModel departmentModel = DepartmentModel(
        name: _deptNameController.text,
        imageUrl: imageDownloadUrl,
        id: widget.dataDetails.id,
        cityId: widget.cityId,
        clinicId: widget.clinicId);
    final res = await DepartmentService.updateData(departmentModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Department Name is already exists");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/DepartmentListPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_deptNameController, "Title*", (item) {
      return item.length > 0 ? null : "Enter department name";
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
