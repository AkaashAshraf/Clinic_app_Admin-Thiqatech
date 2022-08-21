import 'package:demoadmin/screens/userScreen/editUserProfilePage.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class SearchUserByIdPage extends StatefulWidget {
  @override
  _SearchUserByIdPageState createState() => _SearchUserByIdPageState();
}

class _SearchUserByIdPageState extends State<SearchUserByIdPage> {
  List _userList = [];
  bool _isLoading = false;
  bool _isEnableBtn = true;
  bool _isSearchedBefore = false;
  TextEditingController _searchByIdController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose

    _searchByIdController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: SearchBoxWidget(
          controller: _searchByIdController,
          hintText: "Search user Id",
          validatorText: "Enter Id",
        ),
        actions: [
          SearchBtnWidget(
            onPressed: _handleSearchBtn,
            isEnableBtn: _isEnableBtn,
          )
        ],
      ),
      body: Container(
        child: _cardListBuilder(),
      ),
    );
  }

  Widget _cardListBuilder() {
    return ListView(
      children: [
        // _buildUpperBoxContainer(),
        !_isSearchedBefore
            ? Container()
            : _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingIndicatorWidget(),
                  )
                : this._userList.length > 0
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: this._userList.length,
                        itemBuilder: (context, index) {
                          return _buildChatList(this._userList[index]);
                        },
                      )
                    : NoDataWidget()
      ],
    );
  }

  Widget _buildChatList(userList) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditUserProfilePage(userDetails: userList)),
              );
            },
            child: ListTile(
              leading: CircularUserImageWidget(userList: userList),
              title: Text("${userList.firstName} ${userList.lastName}"),
              subtitle: Text("Created at ${userList.createdTimeStamp}"),
              //  isThreeLine: true,
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  _handleSearchBtn() async {
    if (_searchByIdController.text != "") {
      setState(() {
        _isLoading = true;
        _isSearchedBefore = true;
      });

      final res = await UserService.getUserById(_searchByIdController.text);
      setState(() {
        _userList = res;
        _isLoading = false;
      });
    }
  }
}
