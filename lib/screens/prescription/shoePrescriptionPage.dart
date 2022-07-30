import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class ShowPrescriptionImagePage extends StatefulWidget {
  final title;
  final imageUrls;
  final selectedImagesIndex;
  ShowPrescriptionImagePage(
      {Key? key, this.imageUrls, this.title, this.selectedImagesIndex})
      : super(key: key);
  @override
  _ShowPrescriptionImagePageState createState() =>
      _ShowPrescriptionImagePageState();
}

class _ShowPrescriptionImagePageState extends State<ShowPrescriptionImagePage> {
  String _selectedImageUrl = "";
  int totalImg = 0;
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    //print(widget.imageUrls.length);
    //initialize all value
    setState(() {
      _selectedImageUrl = widget.imageUrls[widget.selectedImagesIndex];
      totalImg = widget.imageUrls.length;
      _index = widget.selectedImagesIndex;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: kAppBarTitleStyle,
          ),
          backgroundColor: appBarColor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          //color: Colors.red,
          child: Stack(
            children: [
              Container(
                  child: SwipeDetector(
                onSwipeLeft: (offset) {
                  _forwardImg();
                  // print("Swipe Left");
                },
                onSwipeRight: (offset) {
                  _backwardImg();
                  // print("Swipe Right");
                },
                child: Center(
                    child: ImageBoxContainWidget(imageUrl: _selectedImageUrl)
                    //get image from url
                    ),
              )),
              widget.imageUrls.indexOf(_selectedImageUrl) != totalImg - 1
                  ? Positioned.fill(
                      child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                      ),
                    ))
                  : Container(),
              widget.imageUrls.indexOf(_selectedImageUrl) > 0
                  ? Positioned.fill(
                      child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
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
                      ),
                    ))
                  : Container()
            ],
          ),
        ));
  }

  void _forwardImg() {
    // print(_index);
    //print(totalImg);
    if (_index + 1 <= totalImg - 1) {
      // check more images is remain or not by indexes
      setState(() {
        _selectedImageUrl = widget.imageUrls[_index +
            1]; // if true then set forward to new image by increment the index
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
        _selectedImageUrl = widget.imageUrls[_index -
            1]; // if upper condition is true then decrement the index value and show just backward image
        _index = _index - 1;
      });
    }
  }
}
