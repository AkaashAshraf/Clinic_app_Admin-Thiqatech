import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

import 'package:demoadmin/notificationScreen/sendNotificationPage.dart';

import 'package:demoadmin/utilities/appbars.dart';

class UsersListForNotificationPage extends StatefulWidget {
  @override
  _UsersListForNotificationPageState createState() =>
      _UsersListForNotificationPageState();
}

class _UsersListForNotificationPageState
    extends State<UsersListForNotificationPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "users"),
      body: FutureBuilder(
          future: UserService.getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildChatList(snapshot.data);
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  Widget _buildChatList(userList) {
    return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendNotificationPage(
                              userDetails: userList[index])),
                    );
                  },
                  child: ListTile(
                    leading: CircularUserImageWidget(userList: userList[index]),
                    title: Text(
                        "${userList[index].firstName} ${userList[index].lastName}",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 14.0,
                        )),
                    //         DateFormat _dateFormat = DateFormat('y-MM-d');
                    // String formattedDate =  _dateFormat.format(dateTime);
                    subtitle:
                        Text("Created at ${userList[index].createdTimeStamp}",
                            style: TextStyle(
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 14,
                            )),
                    //  isThreeLine: true,
                  ),
                ),
                Divider()
              ],
            ),
          );
        });
  }
}
