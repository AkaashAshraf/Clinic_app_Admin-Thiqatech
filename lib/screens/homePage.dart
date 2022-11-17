import 'package:demoadmin/service/Notification/handleLocalNotification.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/utilities/clipPath.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _gridScrollController = new ScrollController();
  bool _isLoading = false;
  String doctName = "";
  String doctId = "";
  String userType = "";
  String doctProfile = "";

  List _widgetsList = [
    {
      "iconName": "assets/icons/appoin.svg",
      "title": "Appointments",
      "navigation": "/AppointmentListPage"
    },
    {
      "iconName": "assets/icons/teeth.svg",
      "title": "Service",
      "navigation": "/ServicesPage"
    },

    {
      "iconName": "assets/icons/bell.svg",
      "title": "Notification",
      "navigation": "/NotificationListPage"
    },
    // {
    //   "iconName": "assets/icons/hcity.svg",
    //   "title": "Cities",
    //   "navigation": "/CityListPage"
    // },
    {
      "iconName": "assets/icons/docblog.svg",
      "title": "Categories",
      "navigation": "/categoryPage"
    },
    // {
    //   "iconName": "assets/icons/hospita.svg",
    //   "title": "Clinic",
    //   "navigation": "/ChooseClinicCityListPage"
    // },
    // {
    //   "iconName": "assets/icons/dept.svg",
    //   "title": "Department",
    //   "navigation": "/ChooseDeptCityListPage"
    // },
    // {
    //   "iconName": "assets/icons/doct.svg",
    //   "title": "Doctors",
    //   "navigation": "/ChooseDoctCityListPage"
    // },

    {
      "iconName": "assets/icons/type.svg",
      "title": "Feedback",
      "navigation": "/FeedbackListPage"
    },

    // {
    //   "iconName": "assets/icons/doct.svg",
    //   "title": "Profile",
    //   "navigation": "/EditProfilePage"
    // },

    // {
    //   "iconName": "assets/icons/docblog.svg",
    //   "title": "Health Blog",
    //   "navigation": "/BlogPostPage"
    //   //"/TestimonialsPage"
    // },
    {
      "iconName": "assets/icons/item.png",
      "title": "Items",
      "navigation": "/ItemPage"
      //"/TestimonialsPage"
    },
    {
      "iconName": "assets/icons/gallery.svg",
      "title": "Gallery",
      "navigation": "/EditGalleryPage"
    },
    // {
    //   "iconName": "assets/icons/timing.svg",
    //   "title": "Timing",
    //   "navigation": "/EditOpeningClosingTime"
    // },
    {
      "iconName": "assets/icons/sch.svg",
      "title": "Availability",
      "navigation": "/EditAvailabilityPage"
    },
    {
      "iconName": "assets/icons/type.svg",
      "title": "Types",
      "navigation": "/AppointmentTypesPage"
    },
    // {
    //   "iconName": "assets/icons/booking.svg",
    //   "title": "Setting",
    //   "navigation": "/EditBookingTiming"
    // },
    {
      "iconName": "assets/icons/group.svg",
      "title": "Users",
      "navigation": "/UsersListPage"
    },
    {
      "iconName": "assets/icons/banner.svg",
      "title": "Banner Image",
      "navigation": "/EditBannerImagesPage"
    },
    {
      "iconName": "assets/icons/testi.svg",
      "title": "Testimonials",
      "navigation": "/TestimonialsPage"
    },
    {
      "iconName": "assets/icons/orderhistory.png",
      "title": "Order List",
      "navigation": "/OrderListPage"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    HandleFirebaseNotification.handleNotifications(
        context); //initialize firebase messaging
    HandleLocalNotification.initializeFlutterNotification(
        context); //initialize local notification
    getMsg();
    getAndSetData();
    super.initState();
  }

  getMsg() async {
    final res = await FirebaseMessaging.instance.getToken();
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Stack(
              children: [
                Positioned(
                    top: 0, left: 0, right: 0, child: _bottomCircularBox()),
                Positioned.fill(
                  child: _adminImageAndText(),
                ),
                Positioned(top: 20, right: 5, child: SignOutBtnWidget()),
                Positioned(
                    top: 200,
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: _buildGridView())
              ],
            ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      //  physics: ScrollPhysics(),
      controller: _gridScrollController,
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(_widgetsList.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, _widgetsList[index]["navigation"]);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _widgetsList[index]["title"] == "Notification"
                    ? _buildNotificationIcon(_widgetsList[index]["iconName"])
                    : SizedBox(
                        height: 50,
                        width: 50,
                        child: _widgetsList[index]["iconName"].contains('svg')
                            ? SvgPicture.asset(_widgetsList[index]["iconName"],
                                semanticsLabel: 'Acme Logo')
                            : Image.asset(_widgetsList[index]["iconName"]),
                      ),
                SizedBox(height: 20),
                Text(
                  _widgetsList[index]["title"],
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _bottomCircularBox() {
    return Container(
      alignment: Alignment.center,
      child: ClipPath(
        clipper: ClipPathClass(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(gradient: gradientColor),
        ),
      ),
    );
  }

  Widget _adminImageAndText() {
    return Column(
      children: [
        SizedBox(height: 60),
        userType == "doctor"
            ? doctProfile == ""
                ? Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/dr.png",
                            height: 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    width: 100,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(doctProfile),
                            fit: BoxFit.cover)),
                  )
            : Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/dr.png",
                        height: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
        SizedBox(height: 10),
        userType == "doctor"
            ? Text(
                doctName,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 20.0,
                    color: Colors.white),
              )
            : Text(
                "Admin App",
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 20.0,
                    color: Colors.white),
              )
      ],
    );
  }

  Widget _buildNotificationIcon(widgetName) {
    return StreamBuilder(
        stream: userType == "doctor"
            ? ReadData.fetchDoctorsNotificationDotStatus(doctId)
            : ReadData.fetchNotificationDotStatus(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? SizedBox(
                  height: 45,
                  width: 45,
                  child:
                      SvgPicture.asset(widgetName, semanticsLabel: 'Acme Logo'),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: SvgPicture.asset(widgetName,
                          semanticsLabel: 'Acme Logo'),
                    ),
                    snapshot.data["isAnyNotification"]
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.red,
                            ))
                        : Positioned(top: 0, right: 0, child: Container())
                  ],
                );
        });
  }

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final type = preferences.getString("userType");
    if (type == "doctor") {
      setState(() {
        userType = type ?? "";
        doctId = preferences.getString("doctId") ?? "";
        doctName = preferences.getString('doctName') ?? "";
        doctProfile = preferences.getString('doctImage') ?? "";
        _widgetsList.clear();
        _widgetsList.add(
          {
            "iconName": "assets/icons/appoin.svg",
            "title": "Appointments",
            "navigation": "/AppointmentListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/doct.svg",
            "title": "Profile",
            "navigation": "/EditProfilePage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/bell.svg",
            "title": "Notification",
            "navigation": "/NotificationListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/sch.svg",
            "title": "Manage Date",
            "navigation": "/AddDateToCloseBookingPage"
          },
        );
        // _widgetsList.add(
        //   {
        //     "iconName": "assets/icons/ManageDate.png",
        //     "title": "Block Timing",
        //     "navigation": "/BlockTimePage"
        //   },
        // );
      });
    }
    // else if(type=="admin")
    //   {
    //     setState(() {
    //       _widgetsList.removeAt(4);
    //     });
    //   }
    setState(() {
      _isLoading = false;
    });
  }
}
