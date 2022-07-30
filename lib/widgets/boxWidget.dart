import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class CircularCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  CircularCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child:
                Icon(Icons.camera_enhance_rounded, size: 50, color: iconsColor),
          ),
        ),
      ),
    );
  }
}

class RectCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  RectCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        color: Colors.grey[200],
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child:
                Icon(Icons.camera_enhance_rounded, size: 50, color: iconsColor),
          ),
        ),
      ),
    );
  }
}

class CircularImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  CircularImageWidget({this.onPressed, this.images});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            ClipOval(
              child: AssetThumb(
                asset: images[0],
                height: 150,
                width: 150,
              ),
            ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class RectImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  RectImageWidget({this.onPressed, this.images});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AssetThumb(
                asset: images[0],
                height: 150,
                width: 150,
              ),
            ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ECircularCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  ECircularCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.camera_enhance_rounded,
                size: 50, color: primaryColor),
          ),
        ),
      ),
    );
  }
}

class ERectCameraIconWidget extends StatelessWidget {
  @required
  final onTap;
  ERectCameraIconWidget({this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        color: Colors.grey[200],
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Icon(Icons.camera_enhance_rounded,
                size: 50, color: primaryColor),
          ),
        ),
      ),
    );
  }
}

class ECircularImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  @required
  final imageUrl;
  ECircularImageWidget({this.onPressed, this.images, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            ClipOval(
                child: imageUrl == ""
                    ? AssetThumb(
                        asset: images[0],
                        height: 150,
                        width: 150,
                      )
                    //:Container()
                    : ImageBoxFillWidget(
                        imageUrl: imageUrl,
                      ) //recommended use 200*200 pixel

                ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed, //remove image form the array

                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ERectImageWidget extends StatelessWidget {
  @required
  final images;
  @required
  final onPressed;
  @required
  final imageUrl;
  ERectImageWidget({this.onPressed, this.images, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageUrl == ""
                    ? AssetThumb(
                        asset: images[0],
                        height: 150,
                        width: 150,
                      )
                    //:Container()
                    : ImageBoxFillWidget(
                        imageUrl: imageUrl,
                      ) //recommended use 200*200 pixel

                ),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: onPressed, //remove image form the array

                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class CircularUserImageWidget extends StatelessWidget {
  @required
  final userList;
  CircularUserImageWidget({this.userList});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: ClipOval(
          child: userList.imageUrl == ""
              ? CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: primaryColor,
                  ))
              :
              //:Container()
              ImageBoxFillWidget(imageUrl: userList.imageUrl)),
    );
  }
}

class SearchBoxWidget extends StatelessWidget {
  final controller;
  final hintText;
  final validatorText;
  SearchBoxWidget({this.controller, this.hintText, this.validatorText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        controller: controller,
        validator: (item) {
          return item!.length > 0 ? null : validatorText;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            hoverColor: Colors.red,
            fillColor: Colors.orangeAccent,

            // prefixIcon:Icon(Icons.,),
            //   labelText: "Full Name",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appBarColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appBarColor, width: 1.0),
            )),
      ),
    );
  }
}
