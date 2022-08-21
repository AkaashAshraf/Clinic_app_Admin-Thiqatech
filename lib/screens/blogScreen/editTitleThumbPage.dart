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
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';

class EditTitleThumbPage extends StatefulWidget {
  @required
  final document;
  @required
  final blogPost;
  EditTitleThumbPage({this.document, this.blogPost});
  @override
  _EditTitleThumbPageState createState() => _EditTitleThumbPageState();
}

class _EditTitleThumbPageState extends State<EditTitleThumbPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  String _thumbImageUrl = "";
  List<Asset> _images = <Asset>[];
  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _selectedStatus = "";
  bool _sendNotification = false;
  @override
  void initState() {
    // TODO: implement initState
    print(widget.blogPost.status);
    setState(() {
      _selectedStatus = widget.blogPost.status;
      _thumbImageUrl = widget.blogPost.thumbImageUrl;
    });

    _nameController.text = widget.blogPost.title;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Post"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
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
                    if (_thumbImageUrl == "")
                      if (_images.length == 0)
                        ERectCameraIconWidget(onTap: _handleImagePicker)
                      else
                        ERectImageWidget(
                          onPressed: _removeImage,
                          images: _images,
                          imageUrl: _thumbImageUrl,
                        )
                    else
                      ECircularImageWidget(
                        onPressed: _removeImage,
                        images: _images,
                        imageUrl: _thumbImageUrl,
                      ),
                    _titleInputField(),
                    _statusDropDown(),
                    _selectedStatus == "Published"
                        ? _buildDayCheckedBox()
                        : Container(),
                    DeleteButtonWidget(
                      title: "Delete",
                      onPressed: _takeConfirmationForDelete,
                    )
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

  _takeConfirmationForDelete() {
    DialogBoxes.confirmationBox(context, "Delete Post",
        "Are you sure want to delete this post", _handleDelete);
  }

  _takeConfirmation() {
    if (_images.length > 0 || _thumbImageUrl != "") {
      if (_formKey.currentState!.validate()) {
        DialogBoxes.confirmationBox(context, "Update",
            "Are you sure want to Update this post", _handleUpload);
      }
    } else {
      ToastMsg.showToastMsg("Please select image");
    }
  }

  void _handleUpload() {
    if (_thumbImageUrl == "" && _images.length > 0) {
      _uploadImg();
    } else if (_thumbImageUrl != "") {
      _saveDoc(_thumbImageUrl);
    }
  }

  void _saveDoc(String thumbImageUrl) async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final json = jsonEncode(widget.document.toDelta());
    final blogPostModel = BlogPostModel(
        title: _nameController.text,
        body: json,
        thumbImageUrl: thumbImageUrl,
        status: _selectedStatus,
        fileName: widget.blogPost.fileName,
        id: widget.blogPost.id);
    final uploadData = await BlogPostService.updateData(blogPostModel);
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

  Widget _titleInputField() {
    return InputFields.commonInputField(_nameController, "Title*", (item) {
      return item.length > 0 ? null : "Enter text";
    }, TextInputType.text, 2);
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
      _images.clear();
      _thumbImageUrl = ""; //clean array
    });
  }

  _handleDelete() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });

    final res = await BlogPostService.deleteData(
        widget.blogPost.id, widget.blogPost.fileName);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/BlogPostPage', ModalRoute.withName('/HomePage'));
    } else
      ToastMsg.showToastMsg("Something went wrong");
    setState(() {
      _isLoading = false;
      _isEnableBtn = true;
    });
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
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
      ToastMsg.showToastMsg("Something went wrong");
    }
  }
}
