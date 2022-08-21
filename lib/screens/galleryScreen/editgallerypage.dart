import 'package:demoadmin/screens/galleryScreen/ShowImagesPage.dart';
import 'package:demoadmin/service/galleryService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';

import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';

class EditGalleryPage extends StatefulWidget {
  EditGalleryPage({Key? key}) : super(key: key);

  @override
  _EditGalleryPageState createState() => _EditGalleryPageState();
}

class _EditGalleryPageState extends State<EditGalleryPage> {
  bool isEnableBtn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Gallery"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: isEnableBtn,
          onPressed: _navigateScreen,
          title: "Add Images",
        ),
        body: FutureBuilder(
            future:
                GalleryService.getData(), // fetch all images form the database
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData)
                return snapshot.data.length == 0
                    ? NoDataWidget()
                    : _buildGridView(snapshot.data);
              else if (snapshot.hasError)
                return IErrorWidget(); //if any error then you can also use any other widget here
              else
                return LoadingIndicatorWidget();
            }));
  }

  _navigateScreen() {
    Navigator.pushNamed(context, "/AddGalleryImagesPage");
  }

  Widget _buildGridView(imageUrls) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(imageUrls.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowImagesPage(
                    imageUrls: imageUrls, selectedImagesIndex: index),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: ImageBoxFillWidget(imageUrl: imageUrls[index].imageUrl)
                // get images

                ),
          ),
        );
      }),
    );
  }
}
