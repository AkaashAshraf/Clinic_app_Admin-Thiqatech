import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class SendNotificationPage extends StatefulWidget {
  final userDetails;

  const SendNotificationPage({Key? key, this.userDetails}) : super(key: key);

  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  bool _isEnable = true;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  String _selectedRouteName = "Notification";
  String _selectedRoutePath = "/NotificationPage";
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, 'Send Notification'),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        title: "Send",
        isEnableBtn: _isEnable,
      ), // bottom navigation bar
      body: _isLoading
          ? LoadingIndicatorWidget()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _userProfile(), // upper profile section

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      _inputField("Title", "Enter title", 1, TextInputType.text,
                          _titleController), //common input text field
                      _inputField(
                          "body",
                          "Enter body",
                          3,
                          TextInputType.multiline,
                          _bodyController), //common input text field
                      _dropDownMenu(), //drop down menu for all routes
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Text(
                          "when user tap on notification from notification list then they will navigate to this page",
                          style: TextStyle(
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _takeConfirmation() {
    if (_formKey.currentState!
        .validate()) // check input field is validate or not

      DialogBoxes.confirmationBox(
          context,
          "Send",
          "Are you sure want to send notification",
          _handleSendNotification); // take confirmation from user
  }

  _handleSendNotification() async {
    setState(() {
      _isEnable = false;
      _isLoading = true;
    });

    final notificationModel = NotificationModel(
      title: _titleController.text,
      body: _bodyController.text,
      uId: widget.userDetails.uId,
      routeTo: _selectedRoutePath,
      sendBy: "admin",
      sendFrom: "Admin",
      sendTo: "${widget.userDetails.firstName} ${widget.userDetails.lastName}",
    );
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      HandleFirebaseNotification.sendPushMessage(
        widget.userDetails.fcmId,
        _titleController.text,
        _bodyController.text,
      );
      await UpdateData.updateIsAnyNotification(
          "usersList", widget.userDetails.uId, true);

      ToastMsg.showToastMsg("Successfully send");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/NotificationListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnable = true;
      _isLoading = false;
    });
  }

  Widget _inputField(String labelText, String validatorText, maxLines,
      textInputType, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, textInputType, maxLines);
  }

  Widget _userProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: primaryColor,
          child: Icon(Icons.person, color: Colors.white),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Send To",
                  style: TextStyle(
                    fontFamily: 'OpenSans-SemiBold',
                    fontSize: 14.0,
                  )),
              Text(
                  "Name:    ${widget.userDetails.firstName} ${widget.userDetails.lastName}",
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                    fontSize: 14.0,
                  )),
              Text("Id:    ${widget.userDetails.uId}",
                  style: TextStyle(
                    fontFamily: 'OpenSans-Regular',
                    fontSize: 14.0,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropDownMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Text("Page"),
          SizedBox(
            width: 20,
          ),
          DropdownButton<String>(
            value: _selectedRouteName,
            icon: const Icon(
              Icons.arrow_drop_down_outlined,
              size: 20,
            ),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            onChanged: (String? newValue) {
              setState(() {
                _selectedRouteName = newValue!;
                _setPathName(newValue);
                print(_selectedRoutePath);
              });
            },
            items: <String>[
              'Notification',
              'AboutUs',
              "Service",
              'Appointment',
              //"Chat",
              // "Testimonials",
              "Gallery",
              "Availability",
              "Reach Us",
              "Contact Us",
              "No route"
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _setPathName(String selectedRouteName) {
    switch (selectedRouteName) {
      case "Notification":
        setState(() {
          _selectedRoutePath = "/NotificationPage";
        });
        break;
      case "AboutUs":
        setState(() {
          _selectedRoutePath = "/AboutusPage";
        });
        break;
      case "Service":
        setState(() {
          _selectedRoutePath = "/ServicesPage";
        });

        break;
      case "Appointment":
        //statements;
        setState(() {
          _selectedRoutePath = "/Appointmentstatus";
        });
        break;
      case "Chat":
        setState(() {
          _selectedRoutePath = "/ChatMsgPage";
        });
        break;
      case "Testimonials":
        setState(() {
          _selectedRoutePath = "/TestimonialsPage";
        });
        break;
      case "Gallery":
        setState(() {
          _selectedRoutePath = "/GalleryPage";
        });
        break;
      case "Availability":
        setState(() {
          _selectedRoutePath = "/AvaliblityPage";
        });
        break;
      case "Reach Us":
        setState(() {
          _selectedRoutePath = "/ReachUsPage";
        });
        break;
      case "Contact Us":
        setState(() {
          _selectedRoutePath = "/ContactUsPage";
        });

        break;
      case "No route":
        setState(() {
          _selectedRoutePath = "";
        });

        break;

      default:
        {
          setState(() {
            _selectedRoutePath = "/NotificationPage";
          });
        }
        break;
    }
  }
}
