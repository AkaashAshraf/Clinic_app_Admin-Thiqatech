import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatefulWidget {
  final notificationDetails;
  const NotificationDetailsPage({Key? key, this.notificationDetails})
      : super(key: key);
  @override
  _NotificationDetailsPageState createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _bodyController = new TextEditingController();
  TextEditingController _routeToController = new TextEditingController();
  TextEditingController _sendFromController = new TextEditingController();
  TextEditingController _sendToController = new TextEditingController();
  TextEditingController _uIdController = new TextEditingController();
  TextEditingController _notificationIdController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.notificationDetails.title;
    _bodyController.text = widget.notificationDetails.body;
    _routeToController.text = widget.notificationDetails.routeTo;
    _sendFromController.text = widget.notificationDetails.sendFrom;
    _sendToController.text = widget.notificationDetails.sendTo;
    _uIdController.text = widget.notificationDetails.uId;
    _notificationIdController.text = widget.notificationDetails.id;
    _dateController.text = widget.notificationDetails.createdTimeStamp;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _bodyController.dispose();
    _routeToController.dispose();
    _sendFromController.dispose();
    _sendToController.dispose();
    _uIdController.dispose();
    _notificationIdController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Notification Details",
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: ListView(
        children: [
          InputFields.readableInputField(_titleController, "Title", 1),
          InputFields.readableInputField(_bodyController, "Body", 2),
          InputFields.readableInputField(_routeToController, "Route", 1),
          InputFields.readableInputField(_sendFromController, "Send From", 1),
          InputFields.readableInputField(_sendToController, "Send To", 1),
          InputFields.readableInputField(_dateController, "Date Time", 1),
          InputFields.readableInputField(_uIdController, "User Id", 1),
          InputFields.readableInputField(
              _notificationIdController, "Notification Id", 1),
        ],
      ),
    );
  }
}
