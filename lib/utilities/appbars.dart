import 'package:flutter/material.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';

class IAppBars {
  static commonAppBar(context, String title) {
    return AppBar(
      // iconTheme: IconThemeData(
      //   color: appBarIconColor, //change your color here
      // ),
      title: Text(
        title,
        style: kAppBarTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: appBarColor,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: StreamBuilder(
                stream: ReadData.fetchNotificationDotStatus(),
                builder: (context, AsyncSnapshot snapshot) {
                  return !snapshot.hasData
                      ? Icon(
                          Icons.notifications,
                          color: appBarIconColor,
                        )
                      : IconButton(
                          icon: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: appBarIconColor,
                              ),
                              snapshot.data["isAnyNotification"]
                                  ? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 5,
                                      ),
                                    )
                                  : Positioned(
                                      top: 0, right: 0, child: Container())
                            ],
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/NotificationListPage",
                            );
                          }
                          //

                          );
                }))
      ],
    );
  }
}
