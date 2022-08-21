import 'package:demoadmin/model/galleryModel.dart';
import 'package:demoadmin/service/galleryService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:permission_handler/permission_handler.dart';

class AddGalleryImagesPage extends StatefulWidget {
  @override
  _AddGalleryImagesPageState createState() => _AddGalleryImagesPageState();
}

class _AddGalleryImagesPageState extends State<AddGalleryImagesPage> {
  List<Asset> _images = <Asset>[];
  String _imageName = "";
  int _successUploaded = 1;
  bool _isUploading = false;
  bool _isEnableBtn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Images"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Upload",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      floatingActionButton: _isUploading
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                _checkPermission();
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: iconsColor),
      body: Container(
          width: MediaQuery.of(context).size.width,
          child: _isUploading ? _progressBox() : buildGridView()),
    );
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Upload", "Are you sure want to upload images", _handleUpload);
  }

  Future<void> _loadAssets() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 10); //get images from phone gallery with 10 limit
    setState(() {
      _images = res;
      if (res.length > 0)
        _isEnableBtn = true;
      else
        _isEnableBtn = false;
    });
  }

  _checkPermission() async {
    if (await Permission.camera.status.isGranted) //check camera permission
      _loadAssets();
    else {
      final res = await Permission.camera
          .request(); //if permission is not granted then request for permission
      if (res.isGranted) {
        // if request is granted
        _loadAssets();
      }
    }
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(_images.length, (index) {
        Asset asset = _images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  _handleUpload() {
    setState(() {
      _isUploading = true;
      _isEnableBtn = false;
    });

    _startUploading(); //start uploading images
  }

  _startUploading() async {
    int index = _successUploaded - 1;
    setState(() {
      _imageName = _images[index].name ?? "";
    });

    if (_successUploaded <= _images.length) {
      final res = await UploadImageService.uploadImages(
          _images[index]); //  represent the progress of uploading task
      if (res == "0") {
        ToastMsg.showToastMsg(
            "Sorry, ${_images[index].name} is not in format only JPG, JPEG, PNG, & GIF files are allowed to upload");
        if (_successUploaded < _images.length) {
          //check more images for upload
          setState(() {
            _successUploaded = _successUploaded + 1;
          });
          _startUploading(); //if images is remain to upload then again run this task

        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/EditGalleryPage', ModalRoute.withName('/HomePage'));
        }
      } else if (res == "1") {
        ToastMsg.showToastMsg(
            "Image ${_images[index].name} size must be less the 1MB");
        if (_successUploaded < _images.length) {
          //check more images for upload
          setState(() {
            _successUploaded = _successUploaded + 1;
          });
          _startUploading(); //if images is remain to upload then again run this task

        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/EditGalleryPage', ModalRoute.withName('/HomePage'));
        }
      } else if (res == "2") {
        ToastMsg.showToastMsg(
            "Image ${_images[index].name} size must be less the 1MB");
        if (_successUploaded < _images.length) {
          //check more images for upload
          setState(() {
            _successUploaded = _successUploaded + 1;
          });
          _startUploading(); //if images is remain to upload then again run this task

        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/EditGalleryPage', ModalRoute.withName('/HomePage'));
        }
      } else if (res == "3" || res == "error") {
        ToastMsg.showToastMsg("Something went wrong");
        if (_successUploaded < _images.length) {
          //check more images for upload
          setState(() {
            _successUploaded = _successUploaded + 1;
          });
          _startUploading(); //if images is remain to upload then again run this task

        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/EditGalleryPage', ModalRoute.withName('/HomePage'));
        }
      } else if (res == "") {
        ToastMsg.showToastMsg("Something went wrong");
        if (_successUploaded < _images.length) {
          //check more images for upload
          setState(() {
            _successUploaded = _successUploaded + 1;
          });
          _startUploading(); //if images is remain to upload then again run this task

        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/EditGalleryPage', ModalRoute.withName('/HomePage'));
        }
      } else {
        final galleryModel = GalleryModel(imageUrl: res);
        final isAddedImageUrl = await GalleryService.addData(
            galleryModel); //add data in database with required values
        if (isAddedImageUrl == "success") {
          if (_successUploaded < _images.length) {
            //check more images for upload
            setState(() {
              _successUploaded = _successUploaded + 1;
            });
            _startUploading(); //if images is remain to upload then again run this task

          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/EditGalleryPage', ModalRoute.withName('/HomePage'));
          }
        } else {
          ToastMsg.showToastMsg("Something went wrong");

          setState(() {
            _isUploading = false;
            _isEnableBtn = true;
          });
        }
      }
    }
  }

  Widget _progressBox() {
    //show the uploading progress
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload,
          color: Colors.green,
          size: 100,
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: LoadingIndicatorWidget()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Uploading...... " + _imageName),
        ),
      ],
    );
  }
}
