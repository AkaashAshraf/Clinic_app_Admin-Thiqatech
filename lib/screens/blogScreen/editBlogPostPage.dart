import 'dart:convert';
import 'dart:io';
import 'package:demoadmin/screens/blogScreen/editTitleThumbPage.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/appbars.dart';

import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EditBlogPostPage extends StatefulWidget {
  final blogPost;
  EditBlogPostPage({this.blogPost});

  @override
  _EditBlogPostPageState createState() => _EditBlogPostPageState();
}

class _EditBlogPostPageState extends State<EditBlogPostPage> {
  bool _isLoading = false;
  bool _isEnableBtn = true;
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    // TODO: implement initState
    _getDoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Edit post"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: () {
            _takeConfirmation(context);
          },
          title: "Next",
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    QuillToolbar.basic(
                        controller: _controller,
                        onImagePickCallback: _onImagePickCallback),
                    Expanded(
                      child: Container(
                        child: QuillEditor.basic(
                          //_onImagePickCallback
                          controller: _controller,
                          readOnly: false, // true for view only mode
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }

  _takeConfirmation(context) {
    if (_controller.document.length > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTitleThumbPage(
                  document: _controller.document,
                  blogPost: widget.blogPost,
                )),
      );
    } else {
      ToastMsg.showToastMsg("Please write something");
    }
  }

  void _getDoc() async {
    //print(widget.blogPost.body);
    setState(() {
      _isLoading = true;
    });
    final _viewUrl = widget.blogPost.body;
    final response = await http.get(Uri.parse(_viewUrl));
    if (response.statusCode == 200) {
      var myJSON = jsonDecode(response.body);
      setState(() {
        _controller = QuillController(
            document: Document.fromJson(myJSON),
            selection: TextSelection.collapsed(offset: 0));
        _isLoading = false;
      });
    }
    // print("Data ${res[0].body}");
  }

  Future<String?> _onImagePickCallback(File file) async {
    setState(() {
      _isLoading = true;
    });
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    final imageUrl = await _uploadImg(copiedFile.path.toString());
    setState(() {
      _isLoading = false;
    });
    return imageUrl;
  }

  Future<String?> _uploadImg(imagePath) async {
    final res = await UploadImageService.uploadImagesPath(
        imagePath); //upload image in the database
    //all this error we have sated in the the php files
    if (res == "0") {
      ToastMsg.showToastMsg(
          "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
      return null;
    } else if (res == "1") {
      ToastMsg.showToastMsg("Image size must be less the 1MB");
      return null;
    } else if (res == "2") {
      ToastMsg.showToastMsg(
          "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
      return null;
    } else if (res == "3" || res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
      return null;
    } else if (res == "") {
      ToastMsg.showToastMsg("Something went wrong");
      return null;
    } else
      return res;
  }
}
