import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

class BlockTimePage extends StatefulWidget {
  const BlockTimePage({Key? key}) : super(key: key);

  @override
  _BlockTimePageState createState() => _BlockTimePageState();
}

class _BlockTimePageState extends State<BlockTimePage> {
  List _monBlockTime = [
    {"clt": "10:00", "opt": "12:00"}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Block Timing"),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      children: [
        ExpansionTile(
          title: Text("Monday"),
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: _monBlockTime.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(_monBlockTime[index]['opt']),
                        SizedBox(width: 10),
                        Text("To"),
                        SizedBox(width: 10),
                        Text(_monBlockTime[index]['clt']),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _monBlockTime.removeAt(index);
                        });
                      },
                    ),
                  );
                }),
            ElevatedButton(
                onPressed: () async {
                  TimeRange result = await showTimeRangePicker(
                    //  start: TimeOfDay(
                    // hour: int.parse(_clinicOpeningTime.substring(0, 2)),
                    // minute: int.parse(_clinicOpeningTime.substring(3, 5))),
                    // end: TimeOfDay(
                    //     hour: int.parse(_clinicClosingTime.substring(0, 2)),
                    //     minute: int.parse(_clinicClosingTime.substring(3, 5))),
                    strokeColor: primaryColor,
                    handlerColor: primaryColor,
                    selectedColor: primaryColor,
                    context: context,
                  );

                  setState(() {
                    if (result.toString().substring(17, 22) ==
                        result.toString().substring(37, 42)) {
                      ToastMsg.showToastMsg("please select different times");
                    } else {
                      final opt = result.toString().substring(17, 22);
                      final clt = result.toString().substring(37, 42);
                      bool exists = false;
                      setState(() {
                        for (int i = 0; i < _monBlockTime.length; i++) {
                          if (_monBlockTime[i]['opt'] == opt &&
                              _monBlockTime[i]['clt'] == clt) {
                            exists = true;
                            break;
                          }
                        }
                        if (!exists) {
                          setState(() {
                            _monBlockTime.add({
                              "opt": result.toString().substring(17, 22),
                              "clt": clt
                            });
                          });
                        } else if (exists)
                          ToastMsg.showToastMsg("already exists");
                      });

                      //_isEnableBtn = true;
                    }
                  });
                },
                child: Text("Add New"))
          ],
        ),
        ExpansionTile(title: Text("Tuesday")),
        ExpansionTile(title: Text("Wednesday")),
        ExpansionTile(title: Text("ThrushDay")),
        ExpansionTile(title: Text("Friday")),
        ExpansionTile(title: Text("Saturday")),
        ExpansionTile(title: Text("Sunday"))
      ],
    );
  }
}
