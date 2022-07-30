import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class EditSettingPage extends StatefulWidget {
  @override
  _EditSettingPageState createState() => _EditSettingPageState();
}

class _EditSettingPageState extends State<EditSettingPage> {
  bool _isEnableAllBtn = true;
  TextEditingController _versionNameController = new TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _versionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Settings"),
      body: StreamBuilder(
          stream: ReadData.fetchSettingsStream(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? LoadingIndicatorWidget()
                : ListView(
                    children: [
                      _stopBookingWidget(snapshot.data),
                      SizedBox(height: 10),
                      _technicalIssueWidget(snapshot.data),
                      SizedBox(height: 10),
                      _forceUpdateWidget(snapshot.data),
                      SizedBox(height: 10),
                      // _addDateToCloseBookingWidget(),
                      // SizedBox(height: 10),,
                      _currentVersionWidget(snapshot.data),
                    ],
                  );
          }),
    );
  }

  Widget _stopBookingWidget(bookingDetail) {
    return ListTile(
      title: Text("online booking"),
      subtitle: bookingDetail["stopBooking"]
          ? Text("turn off to start online booking")
          : Text("turn on to stop online booking"),
      trailing: IconButton(
        icon: bookingDetail["stopBooking"]
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: !_isEnableAllBtn
            ? null
            : () {
                _handleUpdate("stopBooking", !bookingDetail["stopBooking"]);
              },
      ),
    );
  }

  Widget _forceUpdateWidget(bookingDetail) {
    return ListTile(
      title: Text("Force update"),
      subtitle: bookingDetail["forceUpdate"]
          ? Text("turn on to show force update alert box")
          : Text("turn off to hide force update alert box"),
      trailing: IconButton(
        icon: bookingDetail["forceUpdate"]
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: !_isEnableAllBtn
            ? null
            : () {
                _handleUpdate("forceUpdate", !bookingDetail["forceUpdate"]);
              },
      ),
    );
  }

  Widget _technicalIssueWidget(data) {
    return ListTile(
      title: Text("Technical issue"),
      subtitle: data["technicalIssue"]
          ? Text("turn off to hide technical issue msg in client app")
          : Text("turn on to show technical issue msg in client app"),
      trailing: IconButton(
        icon: data["technicalIssue"]
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: !_isEnableAllBtn
            ? null
            : () {
                _handleUpdate("technicalIssue", !data["technicalIssue"]);
              },
      ),
    );
  }

  _handleUpdate(String name, value) async {
    setState(() {
      _isEnableAllBtn = false;
    });
    final res = await UpdateData.updateSettings(
        {name: value}); //update settings in firebase
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully changed");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableAllBtn = true;
    });
  }

  // Widget _addDateToCloseBookingWidget() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.pushNamed(context, "/AddDateToCloseBookingPage");
  //     },
  //     child: ListTile(
  //       title: Text("Close Date"),
  //       subtitle: Text("Manage date where you want to close booking"),
  //       trailing: Icon(Icons.arrow_right),
  //     ),
  //   );
  // }

  _currentVersionWidget(data) {
    _versionNameController.text = data['currentVersion'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        controller: _versionNameController,
        onSubmitted: (value) {
          _handleUpdateVersion();
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: "App Version",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  _handleUpdateVersion() {
    String versionName = _versionNameController.text.trim();
    if (versionName != "") {
      _handleUpdate("currentVersion", versionName);
    } else {
      ToastMsg.showToastMsg("Please Enter Version Name");
      print("Please Enter version");
    }
  }
}
