import 'package:demoadmin/screens/blogScreen/addBlogPage.dart';
import 'package:demoadmin/screens/blogScreen/editBlogPostPage.dart';
import 'package:demoadmin/screens/itemsScreen/addItemScreen.dart';
import 'package:demoadmin/service/blogPostService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class BlogPostPage extends StatefulWidget {
  @override
  _BlogPostPageState createState() => _BlogPostPageState();
}

class _BlogPostPageState extends State<BlogPostPage> {
  int _limit = 20;
  int _itemLength = 0;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    _scrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Health Blog"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "New Post",
        onPressed: () {
          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => AddItemScreen()),
            MaterialPageRoute(builder: (context) => NewBlogPostPage()),
          );
        },
        isEnableBtn: true,
      ),
      body: Container(
          child: FutureBuilder(
              future:
                  BlogPostService.getData(_limit), //fetch all service details
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData)
                  return snapshot.data.length == 0
                      ? NoDataWidget()
                      : buildListView(snapshot.data);
                else if (snapshot.hasError)
                  return IErrorWidget(); //if any error then you can also use any other widget here
                else
                  return LoadingIndicatorWidget();
              })),
    );
  }

  Widget buildListView(blogPost) {
    _itemLength = blogPost.length;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: blogPost.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditBlogPostPage(
                                  blogPost: blogPost[index],
                                )),
                      );
                    },
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 5, right: 5, top: 0),
                      leading: imageBox(blogPost[index].thumbImageUrl),
                      title: Text(
                        "${blogPost[index].title}",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 14,
                        ),
                      ),
                      //         DateFormat _dateFormat = DateFormat('y-MM-d');
                      // String formattedDate =  _dateFormat.format(dateTime);
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Updated at ${blogPost[index].updatedTimeStamp}"),
                          Row(
                            children: [
                              blogPost[index].status == "Published"
                                  ? _statusIndicator(Colors.green)
                                  : _statusIndicator(Colors.red),
                              SizedBox(width: 10),
                              Text("${blogPost[index].status}"),
                            ],
                          )
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

  void _scrollListener() {
    _scrollController.addListener(() {
      // print("blength $_itemLength $_limit");
      // print("length $_itemLength $_limit");
      if (_itemLength >= _limit) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _limit += 20;
          });
        }
      }
      // print(_scrollController.offset);
    });
  }
}
