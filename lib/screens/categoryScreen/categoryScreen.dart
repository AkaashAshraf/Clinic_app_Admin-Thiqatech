import 'package:demoadmin/model/categoryModel.dart';
import 'package:demoadmin/screens/categoryScreen/addCategoryScreen.dart';
import 'package:demoadmin/service/categoryService.dart';
import 'package:flutter/material.dart';

import '../../utilities/appbars.dart';
import '../../utilities/toastMsg.dart';
import '../../widgets/bottomNavigationBarWidget.dart';
import '../../widgets/errorWidget.dart';
import '../../widgets/imageWidget.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/noDataWidget.dart';
import '../cityScreen/editCityListPage.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  bool _isLoading = false;
  int? _loadingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add New",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCategoryScreen(
                isUpdate: false,
              ),
            ),
          );
        },
        isEnableBtn: true,
      ),
      appBar: IAppBars.commonAppBar(context, "Categories"),
      body: Container(
          child: FutureBuilder(
              future:
              CategoryService.getData(), //fetch all service details
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData)
                  return snapshot.data.length == 0
                      ? NoDataWidget()
                      : _buildContent(snapshot.data);
                else if (snapshot.hasError)
                  return IErrorWidget(); //if any error then you can also use any other widget here
                else
                  return LoadingIndicatorWidget();
              })),
    );
  }

  _buildContent(List<CategoryModel> categories) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ListView.builder(
      itemCount: categories.length,
        itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddCategoryScreen(
                  isUpdate: true,
                  category: categories[index],
                ),
              ),
            );
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(categories[index].name),
                  _loadingIndex == index && _isLoading ? LoadingIndicatorWidget(): IconButton(onPressed: () {
                    _handleDelete(categories[index], index);
                  }, icon: Icon(Icons.delete_outline_outlined)),
                ],
              ),
            ),
          ),
        );
        },
      )
    );
  }

  // _cardImg(listDetails) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => AddCategoryScreen(
  //             isUpdate: true,
  //           ),
  //         ),
  //       );
  //     },
  //     child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         child: Stack(
  //           children: [
  //             Positioned(
  //                 top: 0,
  //                 left: 0,
  //                 right: 0,
  //                 bottom: 45,
  //                 child:
  //                 listDetails == "" || listDetails == null
  //                     ? Icon(Icons.image)
  //                     : ImageBoxFillWidget(imageUrl: listDetails)),
  //             Positioned(
  //                 bottom: 0,
  //                 left: 0,
  //                 right: 0,
  //                 child: Container(
  //                   height: 45,
  //                   child: Center(
  //                     child: Text(
  //                       listDetails,
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           fontSize: 14, fontFamily: "OpenSans-SemiBold"),
  //                     ),
  //                   ),
  //                 )),
  //           ],
  //         )),
  //   );
  // }

  _handleDelete(CategoryModel category, int index) async {
    setState(() {
      _isLoading = true;
      _loadingIndex = index;
    });

    final res = await CategoryService.deleteData(
        category.id.toString());
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/categoryPage', ModalRoute.withName('/HomePage'));
    } else
      ToastMsg.showToastMsg("Something went wrong");
    setState(() {
      _isLoading = false;
    });
  }
}
