import 'package:demoadmin/model/testimonialsModel.dart';
import 'package:demoadmin/service/tesimonialsService.dart';
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

class EditTestimonialPage extends StatefulWidget {
  final testimonialDetails; //QueryDocumentSnapshot
  const EditTestimonialPage({Key? key, this.testimonialDetails})
      : super(key: key);
  @override
  _EditTestimonialPageState createState() => _EditTestimonialPageState();
}

class _EditTestimonialPageState extends State<EditTestimonialPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _desInputController = new TextEditingController();

  List<Asset> _images = <Asset>[];
  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState

    //initialize all input text field
    _nameController.text = widget.testimonialDetails.name;
    _desInputController.text = widget.testimonialDetails.description;
    _imageUrl = widget.testimonialDetails.imageUrl;
    super.initState();
  }

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
      appBar: IAppBars.commonAppBar(context, "Edit Testimonials"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
        isEnableBtn: _isEnableBtn,
        onPressed: _takeConfirmation,
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
                    _nameInputField(),
                    _desInputField(),
                    _deleteTestimonialBnt()
                  ],
                ),
              ),
            ),
    );
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update data", _handleUpdate);
  }

  Widget _deleteTestimonialBnt() {
    return DeleteButtonWidget(
      onPressed: () {
        DialogBoxes.confirmationBox(
            context,
            "delete",
            "Are you sure want to delete",
            _handleDeleteTestimonial); //take confirmation form the user
      },
      title: "Delete",
    );
  }

  _handleDeleteTestimonial() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await TestimonialsService.deleteData(
        widget.testimonialDetails.id); //delete all details form database
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/TestimonialsPage', ModalRoute.withName('/HomePage'));
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
        _images, mounted, 1); //pick image with limit 1
    //print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

    setState(() {
      _images = res;
    });
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
        _uploadImg(); //upload image in to database

    }
  }

  void _removeImage() {
    setState(() {
      _images.clear(); //clear array
      _imageUrl = "";
    });
  }

  void _uploadImg() async {
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

  _updateDetails(imageDownloadUrl) async {
    final testimonials = TestimonialsModel(
        name: _nameController.text,
        imageUrl: imageDownloadUrl,
        id: widget.testimonialDetails.id,
        description: _desInputController.text);
    final res = await TestimonialsService.updateData(testimonials);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/TestimonialsPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
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
