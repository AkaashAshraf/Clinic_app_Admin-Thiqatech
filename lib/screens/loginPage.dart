import 'dart:developer';

import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/sendMailService.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/authService/authService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isEmailVerificationSend = false;
  // bool _passEmailSending=false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int loginType = 0;
  bool logInLoading = false;
  String userType = "";
  String doctId = "";

  @override
  void initState() {
    // TODO: implement initState
    checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: logInLoading
          ? LoadingIndicatorWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFF01beb2),
                  const Color(0xFF04A99E),
                ],
              )),
              child: Center(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _adminImage(),
                    Text(
                      "Admin App",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login as",
                          style: TextStyle(color: Colors.white),
                        ),
                        Radio(
                          activeColor: Colors.white,
                          value: 0,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),
                        Radio(
                          activeColor: Colors.white,
                          value: 1,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Doctor",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),
                      ],
                    ),
                    _cardContent(),
                    _isLoading ? Container() : passwordResetBtn(),
                    // Text("Admin Demo Id: admin@gmail.com", style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 16
                    // ),),
                    // Text("Password: 12345678", style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 16
                    // )),
                    // SizedBox(height: 10,),
                    // Text("Doctor Demo Id: doctor@gmail.com", style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 16
                    // ),),
                    // Text("Password: 12345678Aa@", style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 16
                    // ))
                  ],
                ),
              ))),
    );
  }

  Widget passwordResetBtn() {
    return TextButton(
        onPressed: _isEmailVerificationSend
            ? null
            : () async {
                if (loginType == 1) {
                  if (_userIdController.text == "") {
                    ToastMsg.showToastMsg("please enter email address");
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    final res =
                        await DrProfileService.getPass(_userIdController.text);
                    if (res == "error") {
                      ToastMsg.showToastMsg("Something went wrong");
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      if (res.length > 0) {
                        final mailRes = await SMTPService.sentMail(
                            _userIdController.text, res[0]['pass']);
                        if (mailRes == "success") {
                          ToastMsg.showToastMsg(
                              "password has been sent to ${_userIdController.text}");
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          ToastMsg.showToastMsg("something went wrong");
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        ToastMsg.showToastMsg("please enter a correct mail");
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  }
                } else {
                  if (_userIdController.text.contains("@")) {
                    setState(() {
                      _isEmailVerificationSend = true;
                    });
                    ToastMsg.showToastMsg("Sending");
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _userIdController.text)
                          .then((value) {
                        print("link sent");
                        setState(() {
                          _isEmailVerificationSend = false;
                          ToastMsg.showToastMsg(
                              "verification link has been sent to ${_userIdController.text} ");
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      ToastMsg.showToastMsg("${e.message}");
                      setState(() {
                        _isEmailVerificationSend = false;
                      });
                    }
                  } else
                    ToastMsg.showToastMsg("Enter a valid email");
                }
              },
        child: Text("Forget or Reset Password",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.white,
            )));
  }

  Widget _userIdField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextFormField(
        cursorColor: primaryColor,
        controller: _userIdController,
        validator: (item) {
          Pattern pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = new RegExp(pattern.toString());
          if (!regex.hasMatch(item!))
            return 'Enter a valid email address';
          else
            return null;
          // return item.contains('@') ? null : "Enter correct email";
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
            ),
            labelText: "User Id",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextFormField(
        cursorColor: primaryColor,
        obscureText: true,
        controller: _passwordController,
        validator: (item) {
          return item!.length > 0 ? null : "Enter password";
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            labelText: "Password",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget _adminImage() {
    return SizedBox(
      height: 120,
      width: 120,
      child: ClipOval(
        child: Image.asset(
          "assets/icons/dr.png",
        ),
      ),
    );
  }

  Widget _cardContent() {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 250,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _userIdField(),
                _passwordField(),
                _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadingIndicatorWidget(),
                      )
                    : _loginBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return LoginButtonsWidget(
      onPressed: _handleLogIn,
      title: "Login",
    );
  }

  void _handleLogIn() async {
    print(loginType);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      if (loginType == 0) {
        final res = await AuthService.signIn(
            _userIdController.text, _passwordController.text);
        if (res) {
          //    final FirebaseAuth auth = FirebaseAuth.instance;
          await setData();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userType", "admin");
          userType = "admin";
          prefs.setBool("isLoggedIn", true);
          Navigator.of(context).pushReplacementNamed("/HomePage");
          ToastMsg.showToastMsg("Logged in");
        } else
          ToastMsg.showToastMsg("Smoothing went wrong");
        setState(() {
          _isLoading = false;
        });
      } else if (loginType == 1) {
        _handlePhpLogin();
      }
    }
  }

  setData() async {
    String fcm = "";

    try {
      fcm = await FirebaseMessaging.instance.getToken() ?? "";
      print("%%%%%");
      print("fcmdidddddddddd+$fcm");
      print("%%%%%");
      if (userType == "admin") {
        await DrProfileService.updateFcmId(fcm);
      } else if (userType == "doctor")
        await DrProfileService.updateDoctFcmId(fcm, doctId);
    } catch (e) {
      print(e);
    }
  }

  void _handlePhpLogin() async {
    log('handle php login');
    final res = await DrProfileService.getCredential(
        _userIdController.text, _passwordController.text);
    print(res);
    if (res.length == 0) {
      ToastMsg.showToastMsg("Wrong id or password");
      setState(() {
        _isLoading = false;
      });
    } else if (res.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userType", "doctor");
      userType = "doctor";
      doctId = res[0].id;
      prefs.setString("doctName", res[0].firstName + " " + res[0].lastName);
      prefs.setString("doctImage", res[0].profileImageUrl);

      prefs.setString("doctId", res[0].id);
      prefs.setBool("isLoggedIn", true);
      await setData();
      Navigator.of(context).pushReplacementNamed("/HomePage");
      ToastMsg.showToastMsg("Logged in");
    }
  }

  void checkLoginStatus() async {
    //   Navigator.pushNamed(context, "/LoginPage");
    setState(() {
      logInLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") != null) {
      if (prefs.getBool("isLoggedIn")!) {
        Navigator.of(context).pushReplacementNamed("/HomePage");
      } else {
        setState(() {
          logInLoading = false;
        });
      }
    }
    setState(() {
      logInLoading = false;
    });
  }
}
