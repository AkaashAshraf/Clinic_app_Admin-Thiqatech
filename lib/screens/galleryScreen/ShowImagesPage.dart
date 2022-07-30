import 'package:demoadmin/service/galleryService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class ShowImagesPage extends StatefulWidget {
  final imageUrls;
  final selectedImagesIndex;

  ShowImagesPage({Key? key, this.imageUrls, this.selectedImagesIndex})
      : super(key: key);
  @override
  _ShowImagesPageState createState() => _ShowImagesPageState();
}

class _ShowImagesPageState extends State<ShowImagesPage> {
  bool _isEnableBtn = true;
  bool _isLoading = false;
  String selectedImageUrl = "";
  int totalImg = 0;
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.imageUrls.length);
    setState(() {
      selectedImageUrl = widget.imageUrls[widget.selectedImagesIndex].imageUrl;
      totalImg = widget.imageUrls.length;
      _index = widget.selectedImagesIndex;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Gallery"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Remove",
          onPressed: _takeConfirmation,
          isEnableBtn: _isEnableBtn,
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                //color: Colors.red,
                child: Stack(
                  children: [
                    Container(
                        child: SwipeDetector(
                      child: Center(
                          child: ImageBoxContainWidget(
                              imageUrl: selectedImageUrl)),
                      onSwipeLeft: (offset) {
                        _forwardImg();
                        print("Swipe Left");
                      },
                      onSwipeRight: (offset) {
                        _backwardImg();
                        print("Swipe Right");
                      },
                    )),
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: IconButton(
                          onPressed: _forwardImg,
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      ),
                    )),
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: IconButton(
                          onPressed: _backwardImg,
                          icon: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context,
        "Delete",
        "Are you sure want to delete this image",
        _handleDelete); // take confirmation to delete the image
  }

  _handleDelete() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await GalleryService.deleteData(
      widget.imageUrls[_index].id,
    ); // delete the image form the database
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/EditGalleryPage', ModalRoute.withName('/'));
    } else
      ToastMsg.showToastMsg("Something went wrong");

    setState(() {
      _isLoading = false;
      _isEnableBtn = true;
    });
  }

  void _forwardImg() {
    // print(_index);
    //print(totalImg);
    if (_index + 1 <= totalImg - 1) {
      // check more images is remain or not by indexes
      setState(() {
        selectedImageUrl = widget.imageUrls[_index + 1]
            .imageUrl; // if true then set forward to new image by increment the index
      });
    }
    if (_index + 1 < totalImg) // check more images is remain or not by indexes
      setState(() {
        _index = _index +
            1; // increment index value by one so user can forward to other remain images
      });
  }

  void _backwardImg() {
    if (_index - 1 >= 0) {
      //if value is less then 0 then it show error show we are checking the value
      setState(() {
        selectedImageUrl = widget.imageUrls[_index - 1]
            .imageUrl; // if upper condition is true then decrement the index value and show just backward image
        _index = _index - 1;
      });
    }
  }
}
