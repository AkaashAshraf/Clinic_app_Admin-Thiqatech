import 'package:demoadmin/model/categoryModel.dart';
import 'package:demoadmin/service/categoryService.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../utilities/appbars.dart';
import '../../utilities/colors.dart';
import '../../utilities/dialogBox.dart';
import '../../utilities/imagePicker.dart';
import '../../utilities/inputField.dart';
import '../../utilities/toastMsg.dart';
import '../../widgets/bottomNavigationBarWidget.dart';
import '../../widgets/boxWidget.dart';
import '../../widgets/buttonsWidget.dart';
import '../../widgets/loadingIndicator.dart';

class AddCategoryScreen extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel? category;
  const AddCategoryScreen({Key? key, required this.isUpdate, this.category}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _nameArController = new TextEditingController();

  List<Asset> _images = <Asset>[];
  bool _isEnableBtn = true;
  bool  _isLoading = false;

  String? _selectedStatus;
  final List<String> _statusList = ['abc', 'status'];

  @override
  void initState() {
    if (widget.isUpdate) {
    _nameController.text = widget.category!.name;
    _nameArController.text = widget.category!.nameAr;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.isUpdate?"Edit Category": "Add Category"),
      bottomNavigationBar: BottomNavBarWidget(
        title: widget.isUpdate? "Update": "Add",
        onPressed: widget.isUpdate? _updateCategory: _addCategory,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading ? LoadingIndicatorWidget() : Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            _nameInputField(),
            SizedBox(height: 15),
            _nameArInputField(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _handleImagePicker() async {
    final res = await ImagePicker.loadAssets(
        _images, mounted, 1); //1 is number of images user can pick
    setState(() {
      _images = res;
    });
  }

  Widget _nameInputField() {
    return InputFields.commonInputField(_nameController, "Category Name En*", (item) {
      return item.length > 0 ? null : "Enter Category name in English";
    }, TextInputType.text, 1);
  }

  Widget _nameArInputField() {
    return InputFields.commonInputField(_nameArController, "Category Name Ar*", (item) {
      return item.length > 0 ? null : "Enter Category name in Arabic";
    }, TextInputType.text, 1);
  }



  _addCategory() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final response = await CategoryService.addData(_nameController.text, _nameArController.text);
    if (response == 'success') {
      ToastMsg.showToastMsg("Successfully Added");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/categoryPage', ModalRoute.withName('/HomePage'));
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }

  }
  _updateCategory() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final response = await CategoryService.updateData(widget.category!.id, _nameController.text, _nameArController.text);
    if (response == 'success') {
      ToastMsg.showToastMsg("Successfully updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/categoryPage', ModalRoute.withName('/HomePage'));
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

}
