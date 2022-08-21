import 'dart:convert';
import 'dart:developer';

import 'package:demoadmin/model/itemModel.dart';
import 'package:demoadmin/service/itemService.dart';
import 'package:flutter/material.dart';

import '../../utilities/appbars.dart';
import '../../utilities/toastMsg.dart';
import '../../widgets/bottomNavigationBarWidget.dart';
import '../../widgets/errorWidget.dart';
import '../../widgets/imageWidget.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/noDataWidget.dart';
import 'addItemScreen.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {

  ScrollController _scrollController = new ScrollController();
  int _itemLength = 0;

  bool _isLoading = false;



  int? _loadingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Items"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "New Item",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen(isUpdate: false,)),
            // MaterialPageRoute(builder: (context) => NewBlogPostPage()),
          );
        },
        isEnableBtn: true,
      ),
      body: Container(
          child: FutureBuilder(
              future:
              ItemService.getData(), //fetch all service details
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData)
                  return snapshot.data.length == 0
                      ? NoDataWidget()
                      : _buildListView(snapshot.data);
                else if (snapshot.hasError)
                  return IErrorWidget(); //if any error then you can also use any other widget here
                else
                  return LoadingIndicatorWidget();
              })),
    );
  }


  Widget _buildListView(List<ItemModel> items) {

    _itemLength = items.length;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            // final images = jsonDecode(items[index].images ?? '').toList();
            // log(images.toString());
            var thumbnail;
            if (items[index].images!.length > 0) {
              thumbnail = items[index].images![0];
            } else {
              thumbnail = '';
            }
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddItemScreen(
                              isUpdate: true,
                              item: items[index],
                            )),
                      );
                    },
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.only(left: 5, right: 5, top: 0),
                      leading: imageBox('https://talibcenter.com/$thumbnail'),


                      title: Text(
                        "${items[index].name}",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 14,
                        ),
                      ),
                      //         DateFormat _dateFormat = DateFormat('y-MM-d');
                      // String formattedDate =  _dateFormat.format(dateTime);
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity: ${items[index].quantity}'),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          // children:
                          //
                          // [Text(
                          //     "Updated at ${items[index]}"),
                          // Row(
                          //   children: [
                          //     items[index] == "Published"
                          //         ? _statusIndicator(Colors.green)
                          //         : _statusIndicator(Colors.red),
                          //     SizedBox(width: 10),
                          //     Text("${items[index]}"),
                          //   ],
                          // )]),
                          _loadingIndex == index && _isLoading ? LoadingIndicatorWidget(): IconButton(onPressed: () {
                            _handleDelete(items[index], index);
                          }, icon: Icon(Icons.delete_outline_outlined)),
                        ],
                      ),
                      //  isThreeLine: true,
                    ),
                  ),
                  Divider()
                ],
              ),
            );
          }),
    );
  }

  Widget imageBox(String imageUrl) {
    return Container(
        width: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ImageBoxFillWidget(imageUrl: imageUrl),
        ));
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 4, backgroundColor: color);
  }

  _handleDelete(ItemModel item, int index) async {
    setState(() {
      _isLoading = true;
      _loadingIndex = index;
    });

    final res = await ItemService.deleteData(
        item.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/ItemPage', ModalRoute.withName('/HomePage'));
    } else
      ToastMsg.showToastMsg("Something went wrong");
    setState(() {
      _isLoading = false;
    });
  }


}
