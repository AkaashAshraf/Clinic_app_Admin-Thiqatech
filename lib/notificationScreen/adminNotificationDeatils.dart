import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminNotificationDetailsPage extends StatefulWidget {
  final notificationDetails;
  const AdminNotificationDetailsPage({Key? key, this.notificationDetails})
      : super(key: key);
  @override
  _AdminNotificationDetailsPageState createState() =>
      _AdminNotificationDetailsPageState();
}

class _AdminNotificationDetailsPageState
    extends State<AdminNotificationDetailsPage> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _bodyController = new TextEditingController();
  TextEditingController _sendByController = new TextEditingController();
  TextEditingController _uIdController = new TextEditingController();
  TextEditingController _notificationIdController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();

  var dateFormat = new DateFormat('d-MM-y');
  var timeFormat = new DateFormat('hh:mm');

  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.notificationDetails.title;
    _bodyController.text = widget.notificationDetails.body;
    _sendByController.text = widget.notificationDetails.sendBy;
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
    _sendByController.dispose();
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
          _inputField(_titleController, "Title"),
          _inputField(_bodyController, "Body"),
          _inputField(_sendByController, "Send By"),
          _inputField(_dateController, "Date Time"),
          _inputField(_uIdController, "User Id"),
          _inputField(_notificationIdController, "Notification Id"),
        ],
      ),
    );
  }

  Widget _inputField(controller, title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            labelText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }
}
