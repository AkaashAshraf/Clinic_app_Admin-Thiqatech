import 'package:demoadmin/screens/testimonialsScreen/editTestimonialsPage.dart';
import 'package:demoadmin/service/tesimonialsService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';

class TestimonialsPage extends StatefulWidget {
  TestimonialsPage({Key? key}) : super(key: key);

  @override
  _TestimonialsPageState createState() => _TestimonialsPageState();
}

class _TestimonialsPageState extends State<TestimonialsPage> {
  ScrollController _scrollController = ScrollController();
  bool _isEnableBtn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Testimonials"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Add Testimonials",
          isEnableBtn: _isEnableBtn,
          onPressed: () {
            Navigator.pushNamed(context, "/AddTestimonialPage");
          },
        ),
        body: FutureBuilder(
            future:
                TestimonialsService.getData(), //fetch all testimonial details
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData)
                return snapshot.data.length == 0
                    ? NoDataWidget()
                    : _listCard(snapshot.data);
              else if (snapshot.hasError)
                return IErrorWidget(); //if any error then you can also use any other widget here
              else
                return LoadingIndicatorWidget();
            }));
  }

  Widget _listCard(testimonials) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: testimonials.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 10, left: 10),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 50, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              testimonials[index].description,
                              style: TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 13,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(testimonials[index].name),
                                  _editBtn(testimonials[index])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                          child: testimonials[index].imageUrl == ""
                              ? Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                )
                              : ImageBoxFillWidget(
                                  imageUrl: testimonials[index].imageUrl)),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _editBtn(testimonials) {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditTestimonialPage(testimonialDetails: testimonials),
            ),
          );
        },
        child: Text(
          "Edit",
          style: TextStyle(color: primaryColor),
        ));
  }
}
