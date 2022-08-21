import 'dart:convert';
import 'package:demoadmin/model/blogPostModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/blogPostService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';

class AddTitleThumbPage extends StatefulWidget {
  @required
  final document;
  AddTitleThumbPage({this.document});
  @override
  _AddTitleThumbPageState createState() => _AddTitleThumbPageState();
}

class _AddTitleThumbPageState extends State<AddTitleThumbPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();

  List<Asset> _images = <Asset>[];
  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _selectedStatus = "Review";
  bool _sendNotification = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Blog Name"),
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
                        ? RectCameraIconWidget(onTap: _handleImagePicker)
                        : RectImageWidget(
                            images: _images,
                            onPressed: _removeImage,
                          ),
                    _titleInputField(),
                    _statusDropDown(),
                    _selectedStatus == "Published"
                        ? _buildDayCheckedBox()
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }

  _buildDayCheckedBox() {
    return CheckboxListTile(
      activeColor: primaryColor,
      title: Text(
        "Send new post notification to all users",
      ),
      value: _sendNotification,
      onChanged: (newValue) {
        setState(() {
          _sendNotification = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  _takeConfirmation() {
    if (_images.length > 0) {
      if (_formKey.currentState!.validate()) {
        DialogBoxes.confirmationBox(context, "Upload",
            "Are you sure want to upload new post", _uploadImg);
      }
    } else {
      ToastMsg.showToastMsg("Please select image");
    }
  }

  void _saveDoc(String thumbImageUrl) async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    var json = jsonEncode(widget.document.toDelta());
    final blogPostModel = BlogPostModel(
        title: _nameController.text,
        body: json,
        thumbImageUrl: thumbImageUrl,
        status: _selectedStatus);
    final uploadData = await BlogPostService.addData(blogPostModel);
    if (uploadData == "success") {
      if (_sendNotification) {
        _handleSendNotification();
      } else {
        ToastMsg.showToastMsg("Successfully updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/BlogPostPage', ModalRoute.withName('/HomePage'));
        setState(() {
          _isLoading = false;
          _isEnableBtn = true;
        });
      }
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }

    //print("Updated $uploadData");
  }

  _handleSendNotification() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final notificationModel = NotificationModel(
        title: "New Post",
        body: _nameController.text,
        uId: "forAll",
        routeTo: "/BlogPostPage",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: "All");
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      HandleFirebaseNotification.sendPushMessage(
        "/topics/all",
        "New Post",
        _nameController.text,
      );
      await UpdateData.updateIsAnyNotificationToALLUsers();

      ToastMsg.showToastMsg("Successfully updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/BlogPostPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  Widget _titleInputField() {
    return InputFields.commonInputField(_nameController, "Title*", (item) {
      return item.length > 0 ? null : "Enter title";
    }, TextInputType.text, 2);
  }

  // Widget _noImageBox() {
  //   return Container(
  //       color: Colors.grey,
  //       width: 200,
  //       height: 200,
  //       child:
  //           IconButton(icon: Icon(Icons.add), onPressed: _handleImagePicker));
  // }

  _uploadImg() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });

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
      _saveDoc(res);

    setState(() {
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });
    });
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //pick image with one limit
    setState(() {
      _images = res;
    });
  }

  void _removeImage() {
    setState(() {
      _images.clear(); //clean array
    });
  }

  _statusDropDown() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: DropdownButton<String>(
          focusColor: Colors.white,
          value: _selectedStatus,
          //elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: btnColor,
          items: <String>["Published", "Review"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Status",
          ),
          onChanged: (String? value) {
            if (value == "Review") {
              setState(() {
                _selectedStatus = value!;
                _sendNotification = false;
              });
            } else {
              setState(() {
                print(value);
                _selectedStatus = value!;
              });
            }
          },
        ),
      ),
    );
  }
}
