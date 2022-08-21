import 'package:demoadmin/screens/userScreen/editUserProfilePage.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  Widget build(BuildContext context) {
    bool _isEnableBtn = true;
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "users"),
      bottomNavigationBar: BottomNavTwoBarWidget(
        firstBtnOnPressed: _handleByNameBtn,
        firstTitle: "Search By Name",
        isenableBtn: _isEnableBtn,
        secondBtnOnPressed: _handleByIdBtn,
        secondTitle: "Search By ID",
      ),
      body: FutureBuilder(
          future: UserService.getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildUserList(snapshot.data);
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  _handleByNameBtn() {
    Navigator.pushNamed(context, "/SearchUserByNamePage");
  }

  _handleByIdBtn() {
    Navigator.pushNamed(context, "/SearchUserByIdPage");
  }

  Widget _buildUserList(userList) {
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
                          builder: (context) => EditUserProfilePage(
                              userDetails: userList[index])),
                    );
                  },
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_right,
                      color: primaryColor,
                    ),

                    leading: CircularUserImageWidget(userList: userList[index]),
                    title: Text(
                        "${userList[index].firstName} ${userList[index].lastName}"),
                    //         DateFormat _dateFormat = DateFormat('y-MM-d');
                    // String formattedDate =  _dateFormat.format(dateTime);
                    subtitle:
                        Text("Created at ${userList[index].createdTimeStamp}"),
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
