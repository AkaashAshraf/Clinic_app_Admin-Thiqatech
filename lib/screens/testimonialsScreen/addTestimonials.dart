import 'package:demoadmin/model/testimonialsModel.dart';
import 'package:demoadmin/service/tesimonialsService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class AddTestimonialPage extends StatefulWidget {
  @override
  _AddTestimonialPageState createState() => _AddTestimonialPageState();
}

class _AddTestimonialPageState extends State<AddTestimonialPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<Asset> _images = <Asset>[];
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _desInputController = new TextEditingController();
  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.clear();
    _desInputController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Testimonials"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
        title: "Add",
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
                    _images.length == 0
                        ? CircularCameraIconWidget(
                            onTap: _handleImagePicker,
                          )
                        : CircularImageWidget(
                            onPressed: _removeImage,
                            images: _images,
                          ),
                    _nameInputField(),
                    _desInputField()
                  ],
                ),
              ),
            ),
    );
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Add",
        "Are you sure want to add new testimonial",
        _handleUpload); //take confirmation from user
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //1 represent the number of image user can pick
    // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

    setState(() {
      _images = res;
    });
  }

  _handleUpload() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
      _images.length > 0
          ? _uploadImg()
          : _uploadData(""); //check user selected image or not
    }
  }

  void _removeImage() {
    setState(() {
      _images.clear(); //clear array
    });
  }

  _uploadData(imageDownloadUrl) async {
    final testimonialModel = TestimonialsModel(
        description: _desInputController.text,
        imageUrl: imageDownloadUrl,
        name: _nameController.text);
    final res = await TestimonialsService.addData(
        testimonialModel); //upload data with all required details
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Uploaded");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/TestimonialsPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg('Something went wrong');
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _uploadImg() async {
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
      await _uploadData(res);

    setState(() {
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });
    });
  }

  Widget _nameInputField() {
    return InputFields.commonInputField(_nameController, "Full Name", (item) {
      return item.length > 0 ? null : "Enter full name";
    }, TextInputType.text, 1);
  }

  Widget _desInputField() {
    return InputFields.commonInputField(_desInputController, "Description",
        (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, 8);
  }
}
