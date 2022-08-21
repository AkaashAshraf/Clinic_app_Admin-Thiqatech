import 'package:demoadmin/screens/feedbackDetails.dart';
import 'package:demoadmin/service/feedbackservice.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class FeedbackListPage extends StatefulWidget {
  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  bool _isLoading = false;
  int _userLimit = 20;
  int _userItemLength = 0;
  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    _userScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Feedback"),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : FutureBuilder(
                future: FeedbackService.getData(_userLimit), //fetch all times
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0)
                      return NoDataWidget();
                    else {
                      _userItemLength = snapshot.data.length;
                      return _buildCard(snapshot.data);
                    }
                  } else if (snapshot.hasError)
                    return IErrorWidget(); //if any error then you can also use any other widget here
                  else
                    return LoadingIndicatorWidget();
                }));
  }

  void _userScrollListener() {
    scrollController.addListener(() {
      if (_userItemLength >= _userLimit) {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          setState(() {
            _userLimit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }

  Widget _buildCard(data) {
    return ListView.builder(
        controller: scrollController,
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedbackDetailsPage(
                              feedbackDetails: data[index],
                            )),
                  );
                },
                title: Text(data[index].name),
                subtitle: Text(data[index].date),
                trailing: Icon(Icons.arrow_right),
              ),
              Divider()
            ],
          );
        });
  }
}
