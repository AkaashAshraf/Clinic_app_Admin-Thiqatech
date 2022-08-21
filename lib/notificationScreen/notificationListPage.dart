import 'package:demoadmin/notificationScreen/adminNotificationDeatils.dart';
import 'package:demoadmin/service/adminNotificationService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/notificationScreen/notificationDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  bool _isEnableBtn = true;
  bool _isLoading = false;
  int _adminLimit = 20;
  int _userLimit = 20;
  int _adminItemLength = 0;
  int _userItemLength = 0;
  ScrollController _adminScrollController = new ScrollController();
  ScrollController _userScrollController = new ScrollController();
  String userType = "";
  String doctId = "";

  @override
  void initState() {
    // TODO: implement initState
    _getAndSetData();
    _adminScrollListener();
    _userScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: userType == "doctor" ? 1 : 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "Notification",
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          backgroundColor: appBarColor,
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.all(8),
            tabs: userType == "doctor"
                ? [
                    Text(
                      "Admin",
                      style: kAppBarTitleStyle,
                    ),
                  ]
                : [
                    Text(
                      "Admin",
                      style: kAppBarTitleStyle,
                    ),
                    Text(
                      "User",
                      style: kAppBarTitleStyle,
                    ),
                  ],
          ),
        ),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Send to",
          onPressed: _openDialogForSend,
          isEnableBtn: _isEnableBtn,
        ),
        body: userType == "doctor"
            ? TabBarView(children: [_admin()])
            : TabBarView(children: [_admin(), _user()]),
      ),
    );
  }

  _admin() {
    return _isLoading
        ? LoadingIndicatorWidget()
        : FutureBuilder(
            future: userType == "doctor"
                ? AdminNotificationService.getDataByDoctId(_adminLimit, doctId)
                : AdminNotificationService.getData(
                    _adminLimit), //fetch all times
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0)
                  return NoDataWidget();
                else {
                  _adminItemLength = snapshot.data.length;
                  return _buildCard(snapshot.data, _adminScrollController);
                }
              } else if (snapshot.hasError)
                return IErrorWidget(); //if any error then you can also use any other widget here
              else
                return LoadingIndicatorWidget();
            });
  }

  _user() {
    return _isLoading
        ? LoadingIndicatorWidget()
        : FutureBuilder(
            future: NotificationService.getData(_userLimit), //fetch all times
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0)
                  return NoDataWidget();
                else {
                  _userItemLength = snapshot.data.length;
                  return _buildCard(snapshot.data, _userScrollController);
                }
              } else if (snapshot.hasError)
                return IErrorWidget(); //if any error then you can also use any other widget here
              else
                return LoadingIndicatorWidget();
            });
  }

  _openDialogForSend() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Text("Send to"),
          content: Text(
              "Tap on user to send message a particular user\n\nTap on all to send message to all users"),
          actions: <Widget>[
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text("User", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.popAndPushNamed(
                      context, "/UsersListForNotificationPage");
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: btnColor,
                ),
                child: new Text(
                  "All",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // onPressed();
                  Navigator.popAndPushNamed(
                      context, "/SendNotificationToAllUserPage");
                })
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  Widget _buildCard(notificationDetails, controller) {
    return ListView.builder(
        controller: controller,
        itemCount: notificationDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (notificationDetails[index].status == "admin")
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminNotificationDetailsPage(
                          notificationDetails: notificationDetails[
                              index]), //send to data to the next screen
                    ),
                  );
                });
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailsPage(
                        notificationDetails: notificationDetails[
                            index]), //send to data to the next screen
                  ),
                );
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    notificationDetails[index].title,
                    style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 14.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${notificationDetails[index].body}",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${notificationDetails[index].createdTimeStamp}",
                        style: TextStyle(
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _setRedDot() async {
    setState(() {
      _isLoading = true;
    });
    if (userType == "doctor")
      await UpdateData.updateIsAnyNotification("doctorsNoti", doctId, false);
    else
      await UpdateData.updateIsAnyNotification("profile", "profile", false);
    setState(() {
      _isLoading = false;
    });
  }

  void _adminScrollListener() {
    _adminScrollController.addListener(() {
      // print("blength $_itemLength $_limit");
      //print("length $_adminItemLength $_adminLimit");
      if (_adminItemLength >= _adminLimit) {
        if (_adminScrollController.offset ==
            _adminScrollController.position.maxScrollExtent) {
          setState(() {
            _adminLimit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }

  void _userScrollListener() {
    _userScrollController.addListener(() {
      // print("blength $_itemLength $_limit");
      //  print("length $_userItemLength $_userLimit");
      if (_userItemLength >= _userLimit) {
        if (_userScrollController.offset ==
            _userScrollController.position.maxScrollExtent) {
          setState(() {
            _userLimit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }

  void _getAndSetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString("userType") ?? "";
    if (userType == "doctor") {
      doctId = prefs.getString("doctId") ?? "";
    }
    _setRedDot();
  }
}
