import 'package:demoadmin/service/serviceService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/screens/serviceScreen/editServicePage.dart';
import 'package:demoadmin/utilities/appbars.dart';

class ServicesPage extends StatefulWidget {
  ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool _isEnableBtn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Edit Service"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Add Service",
          onPressed: () {
            Navigator.pushNamed(context, "/AddServicePage");
          },
          isEnableBtn: _isEnableBtn,
        ),
        body: Container(
            child: FutureBuilder(
                future: ServiceService.getData(), //fetch all service details
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    return snapshot.data.length == 0
                        ? NoDataWidget()
                        : buildGridView(snapshot.data);
                  else if (snapshot.hasError)
                    return IErrorWidget(); //if any error then you can also use any other widget here
                  else
                    return LoadingIndicatorWidget();
                })));
  }

  Widget buildGridView(service) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: .8,
        crossAxisCount: 2,
        children: List.generate(service.length, (index) {
          return cardImg(service[index]);
        }),
      ),
    );
  }

  Widget cardImg(serviceDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditServicePage(
                serviceDetails:
                    serviceDetails), //send to data to the next screen
          ),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 45,
                  child: serviceDetails.imageUrl == "" ||
                          serviceDetails.imageUrl == null
                      ? Icon(Icons.image)
                      : ImageBoxFillWidget(imageUrl: serviceDetails.imageUrl)),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 45,
                    child: Center(
                      child: Text(
                        serviceDetails.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
