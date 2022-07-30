import 'package:demoadmin/service/bannerService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class EditBannerImagesPage extends StatefulWidget {
  @override
  _EditBannerImagesPageState createState() => _EditBannerImagesPageState();
}

class _EditBannerImagesPageState extends State<EditBannerImagesPage> {
  bool _isLoading = false;
  bool _isUploading = false;

  String _id = "";
  var _images = <Asset>[];
  List<Asset> _firstBannerImageAsset = <Asset>[];
  List<Asset> _secondBannerImageAsset = <Asset>[];
  List<Asset> _thirdBannerImageAsset = <Asset>[];
  List<Asset> _fourthBannerImageAsset = <Asset>[];
  String _firstBannerImageUrl = "";
  String _secondBannerImageUrl = "";
  String _thirdBannerImageUrl = "";
  String _fourthBannerImageUrl = "";

  @override
  void initState() {
    // TODO: implement initState

    getAndSetData(); //get and set all initial data
    super.initState();
  }

  getAndSetData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await BannerImageService.getData(); //fetch all banner image url

    //set all initial image urls
    setState(() {
      _firstBannerImageUrl = res[0].banner1;
      _secondBannerImageUrl = res[0].banner2;
      _thirdBannerImageUrl = res[0].banner3;
      _fourthBannerImageUrl = res[0].banner4;
      _id = res[0].id;
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Banner Images"),
        //bottomNavigationBar: Buttons.bottomBtn(context, "Update", _takeConfirmation, _isEnableBtn),
        body: _isLoading
            ? Center(child: LoadingIndicatorWidget())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _firstBannerImage(),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        //banner 1,2,3 is used because this is tha key value in the database
                        child: _firstBannerImageAsset.length > 0
                            ? _uploadBtn(_firstBannerImageAsset, "banner1")
                            : Container() //if user select the image from image pucker then we show the upload btn
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            _secondBannerImage(),
                            _secondBannerImageAsset.length > 0
                                ? _uploadBtn(_secondBannerImageAsset, "banner2")
                                : Container() //if user select the image from image pucker then we show the upload btn
                          ],
                        ),
                        Column(
                          children: [
                            _thirdBannerImage(),
                            _thirdBannerImageAsset.length > 0
                                ? _uploadBtn(_thirdBannerImageAsset, "banner3")
                                : Container() //if user select the image from image pucker then we show the upload btn
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _fourthBannerImage(),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: _fourthBannerImageAsset.length > 0
                            ? _uploadBtn(_fourthBannerImageAsset, "banner4")
                            : Container() //if user select the image from image pucker then we show the upload btn
                        )
                  ],
                ),
              ));
  }

  Widget _firstBannerImage() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,
            child:
                _firstBannerImageAsset.length == 0 && _firstBannerImageUrl == ""
                    ? //if user remove the image
                    Icon(Icons.image)
                    : _firstBannerImageAsset.length > 0
                        ? // if user has selected the image
                        AssetThumb(
                            asset: _firstBannerImageAsset[0],
                            height: 500,
                            width: 500)
                        : ImageBoxFillWidget(imageUrl: _firstBannerImageUrl)),
        Positioned(
            top: 5,
            right: 5,
            child: _firstBannerImageAsset.length == 0 &&
                    _firstBannerImageUrl ==
                        "" // if user has removed the images then we will show the add image btn
                ? _addImageBtn("_firstBannerImageAsset")
                : _removeBtn("_firstBannerImageAsset"))
      ],
    );
  }

  Widget _secondBannerImage() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width * .45,
            child: _image(_secondBannerImageUrl,
                _secondBannerImageAsset) //recommended size 200*200 pixel
            //_image('assets/images/offer3.jpeg'),
            ),
        Positioned(
            top: 0,
            right: 0,
            child: _secondBannerImageAsset.length == 0 &&
                    _secondBannerImageUrl ==
                        "" // if user has removed the images then we will show the add image btn
                ? _addImageBtn("_secondBannerImageAsset")
                : _removeBtn("_secondBannerImageAsset"))
      ],
    );
  }

  Widget _thirdBannerImage() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width * .45,
            child: _image(_thirdBannerImageUrl,
                _thirdBannerImageAsset) //recommended size 200*200 pixel
            //_image('assets/images/offer3.jpeg'),
            ),
        Positioned(
            top: 0,
            right: 0,
            child: _thirdBannerImageAsset.length == 0 &&
                    _thirdBannerImageUrl ==
                        "" // if user has removed the images then we will show the add image btn
                ? _addImageBtn("_thirdBannerImageAsset")
                : _removeBtn("_thirdBannerImageAsset"))
      ],
    );
  }

  Widget _fourthBannerImage() {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 20, top: 0.0, bottom: 20.0),
      child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width,
              child: _image(_fourthBannerImageUrl,
                  _fourthBannerImageAsset) //recommended size 200*400 pixel
              ),
          Positioned(
              top: 0,
              right: 0,
              child: _fourthBannerImageAsset.length == 0 &&
                      _fourthBannerImageUrl ==
                          "" // if user has removed the images then we will show the add image btn
                  ? _addImageBtn("_fourthBannerImageAsset")
                  : _removeBtn("_fourthBannerImageAsset"))
        ],
      ),
    );
  }

  Widget _image(String imageurl, bannerImageAsset) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: bannerImageAsset.length == 0 && imageurl == ""
                ? Icon(Icons.image)
                : bannerImageAsset.length > 0
                    ? //if user has selected image
                    AssetThumb(
                        asset: bannerImageAsset[0], width: 500, height: 500)
                    : ImageBoxFillWidget(imageUrl: imageurl)));
  }

  Widget _removeBtn(bannerImageAsset) {
    return IconButton(
        icon: Icon(
          Icons.remove_circle,
          color: Colors.red,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            // here we clear the selected banner asset and image url

            if (bannerImageAsset == "_thirdBannerImageAsset") {
              _thirdBannerImageAsset.clear();
              _thirdBannerImageUrl = "";
            }
            if (bannerImageAsset == "_fourthBannerImageAsset") {
              _fourthBannerImageAsset.clear();
              _fourthBannerImageUrl = "";
            }
            if (bannerImageAsset == "_secondBannerImageAsset") {
              _secondBannerImageAsset.clear();
              _secondBannerImageUrl = "";
            }
            if (bannerImageAsset == "_firstBannerImageAsset") {
              //print("HHHHHHHHHHHHHHHHHHHHHHHH");
              _firstBannerImageAsset.clear();
              _firstBannerImageUrl = "";
              // print(_firstBannerImageAsset.length);
            }
          });
        });
  }

  Widget _addImageBtn(bannerImageAsset) {
    return CircleAvatar(
      backgroundColor: primaryColor,
      radius: 20,
      child: IconButton(
        icon: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 50,
            child: Icon(
              Icons.camera_enhance_rounded,
              color: Colors.white,
              size: 20,
            )),
        onPressed: () {
          _handleImagePicker(bannerImageAsset);
        },
      ),
    );
  }

  void _handleImagePicker(bannerImageAsset) async {
    //bannerImageAsset variable take a name of the taped banner so we can proceed only with the banner
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,$bannerImageAsset");
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //1 is number of images user can pick
    // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");

    setState(() {
      //if user has picked image then we set image to selected banner asset array and remove image url
      if (bannerImageAsset == "_thirdBannerImageAsset") {
        _thirdBannerImageAsset = res;
        _thirdBannerImageUrl = "";
      }

      if (bannerImageAsset == "_fourthBannerImageAsset") {
        _fourthBannerImageAsset = res;
        _fourthBannerImageUrl = "";
      }

      if (bannerImageAsset == "_secondBannerImageAsset") {
        _secondBannerImageAsset = res;
        _secondBannerImageUrl = "";
      }

      if (bannerImageAsset == "_firstBannerImageAsset") {
        _firstBannerImageAsset = res;
        _firstBannerImageUrl = "";
      }

      // _secondBannerImageAsset=res;
    });
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$bannerImageAsset");
  }

  Widget _uploadBtn(bannerImageAsset, bannerImageName) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: btnColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        child: Center(
            child: Text("Upload",
                style: TextStyle(
                  color: Colors.white,
                ))),
        onPressed: _isUploading
            ? null
            : () {
                _startUploading(bannerImageAsset,
                    bannerImageName); //start process of uploading image
              });
  }

  _startUploading(bannerImageAsset, bannerImageName) async {
    setState(() {
      _isLoading = true;
      _isUploading = true;
    });

    final res = await UploadImageService.uploadImages(bannerImageAsset[0]);
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
      await _updateDetails(res, bannerImageName);

    setState(() {
      _isLoading = false;
      _isUploading = false;
    });
  }

  _updateDetails(imageDownloadUrl, bannerImageName) async {
    final res = await BannerImageService.updateData(
        _id, bannerImageName, imageDownloadUrl);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/EditBannerImagesPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
      _isUploading = false;
    });
  }
}
