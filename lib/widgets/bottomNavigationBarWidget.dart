import 'package:demoadmin/utilities/colors.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  @required
  final title;
  @required
  final isEnableBtn;
  @required
  final onPressed;
  BottomNavBarWidget({this.title, this.isEnableBtn, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 8.0, bottom: 8.0),
            child: SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  child: Center(
                      child: Text(title,
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                  onPressed: isEnableBtn ? onPressed : null),
            )));
  }
}

class BottomNavTwoBarWidget extends StatelessWidget {
  @required
  final firstTitle;
  @required
  final isenableBtn;
  @required
  final firstBtnOnPressed;
  @required
  final secondTitle;
  @required
  final secondBtnOnPressed;
  BottomNavTwoBarWidget(
      {this.firstTitle,
      this.firstBtnOnPressed,
      this.secondTitle,
      this.secondBtnOnPressed,
      this.isenableBtn});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 8.0, bottom: 8.0),
            child: SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: btnColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: Center(
                            child: Text(firstTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                        onPressed: isenableBtn ? firstBtnOnPressed : null),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: btnColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: Center(
                            child: Text(secondTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                        onPressed: isenableBtn ? secondBtnOnPressed : null),
                  ),
                ],
              ),
            )));
  }
}
