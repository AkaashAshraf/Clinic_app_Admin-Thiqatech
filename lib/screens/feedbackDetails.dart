import 'package:demoadmin/utilities/appbars.dart';
import 'package:flutter/material.dart';

class FeedbackDetailsPage extends StatefulWidget {
  final feedbackDetails;
  FeedbackDetailsPage({this.feedbackDetails});

  @override
  _FeedbackDetailsPageState createState() => _FeedbackDetailsPageState();
}

class _FeedbackDetailsPageState extends State<FeedbackDetailsPage> {
  var textList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      textList =
          widget.feedbackDetails.feedbacktext.toString().split("*-*-##*-+");
    });
  }

  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.feedbackDetails.name),
      body: ListView(
        controller: scrollController,
        children: [
          ListView.builder(
              controller: scrollController,
              itemCount: textList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [ListTile(title: Text(textList[index])), Divider()],
                );
              }),
        ],
      ),
    );
  }
}
