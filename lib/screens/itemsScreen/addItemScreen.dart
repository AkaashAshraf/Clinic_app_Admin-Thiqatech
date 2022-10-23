import 'dart:developer';
import 'dart:io';

import 'package:demoadmin/model/itemModel.dart';
import 'package:demoadmin/service/categoryService.dart';
import 'package:demoadmin/service/itemService.dart';
import 'package:flutter/material.dart';

import '../../model/categoryModel.dart';
import '../../utilities/appbars.dart';
import '../../utilities/colors.dart';
import '../../utilities/inputField.dart';
import '../../utilities/toastMsg.dart';
import '../../widgets/bottomNavigationBarWidget.dart';
import '../../widgets/errorWidget.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/photos_selector.dart';

class AddItemScreen extends StatefulWidget {
  final bool isUpdate;
  final ItemModel? item;
  const AddItemScreen({Key? key, required this.isUpdate, this.item})
      : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool _isEnableBtn = true;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> _categoryList = <String>[];
  final List<String> _taxTypeList = <String>["abc", "xyz"];
  final List<String> _discountTypeList = <String>["abc", "xyz"];
  final List<String> _statusList = <String>["abc", "xyz"];
  List<String>? _categoryIds = [];
  List<CategoryModel> _selectedCategories = [];
  String? _selectedCategory;
  String? _selectedTaxType;
  String? _selectedDiscountType;
  String? _selectedStatus;

  List<CategoryModel> categories = [];

  bool _isRefundable = false;
  bool _isFreeShipping = false;

  List<dynamic> _photos = [];
  List<CategoryModel> _itemCategories = [];

  bool isFirstRun = false;

  final _nameController = new TextEditingController();
  final _nameArController = new TextEditingController();
  final _discountController = new TextEditingController();
  final _taxController = new TextEditingController();
  final _pPriceController = new TextEditingController();
  final _uPriceController = new TextEditingController();
  final _minQtyController = new TextEditingController();
  final _detailController = new TextEditingController();
  final _detailArController = new TextEditingController();
  final _currentStockController = new TextEditingController();
  final _deniedNoteController = new TextEditingController();
  final _videoUrlController = new TextEditingController();

  _setData() {
    _nameController.text = widget.item!.name;
    _nameArController.text = widget.item!.nameAr;
    _minQtyController.text = widget.item!.quantity ?? '0';
    _photos.addAll(widget.item!.images!);
    _categoryIds = widget.item!.categoryIds;
    _detailController.text = widget.item!.itemDetailsEn ?? 'abc';
    _detailArController.text = widget.item!.itemDetailsAr ?? '';
    _uPriceController.text = widget.item!.sharePrice ?? '0';
    isFirstRun = true;
    // _images = widget.item!.images as List<Asset>;
    // _discountController.text = 'discount';
    // _taxController.text = 'tax';
    // _pPriceController.text = 'purchase price';
    // _uPriceController.text = 'unit price';
    // _minQtyController.text = 'min quantity';
    // _detailController.text = 'detail';
    // _currentStockController.text = 'current stock';
    // _deniedNoteController.text = 'denied note';
    // _videoUrlController.text = 'video url';
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      _setData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(
            context, widget.isUpdate ? "Edit Item" : "Add Item"),
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: () {
            if (!_formKey.currentState!.validate() && _photos.isEmpty) return;
            widget.isUpdate ? _updatedItem() : _addItem();
          },
          title: widget.isUpdate ? "Updated" : "Add",
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : FutureBuilder(
                future: CategoryService.getData(), //fetch all service details
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    categories = snapshot.data;
                    if (isFirstRun) {
                      _selectedCategories.addAll(categories
                          .where(
                              (category) => _categoryIds!.contains(category.id))
                          .toList());
                      isFirstRun = false;
                    }

                    log(_selectedCategories.toString());
                    return _buildForm();
                  } else if (snapshot.hasError)
                    return IErrorWidget(); //if any error then you can also use any other widget here
                  else
                    return LoadingIndicatorWidget();
                }));
  }

  Widget _buildCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _selectedCategories.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140,
                  childAspectRatio: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            _selectedCategories[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategories.removeAt(index);
                              });
                            },
                            child: Icon(Icons.remove_circle,
                                size: 16, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _buildForm() {
    _categoryList = [];
    categories.map((e) => _categoryList.add(e.name)).toList();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            // _images.length == 0
            //     ? RectCameraIconWidget(onTap: _handleImagePicker)
            //     : RectImageWidget(
            //   images: _images,
            //   onPressed: _removeImage,
            // ),
            _titleInputField(),
            _titleArInputField(),
            SizedBox(height: 8),
            _minimumQuantityInputField(),
            _unitPriceInputField(),
            _detailInputField(),
            _detailArInputField(),
            _categoryDropDown(),
            _buildCategoryView(),
            SizedBox(height: 20),
            PhotosSelector(
              photos: _photos,
              onChanged: (photos) => _photos = photos,
            ),
            // _purchasePriceInputField(),
            // _taxPriceInputField(),
            // _taxTypeDropDown(),
            // _discountInputField(),
            // _discountTypeDropDown(),
            // _currentStockInputField(),
            // _statusDropDown(),
            // _videoUrlInputField(),
            // _detailInputField(),
            // _deniedNoteInputField(),

            // _buildFreeShippingCheckedBox(),
            // _buildRefundableCheckedBox(),
          ],
        ),
      ),
    );
  }

  Widget _titleInputField() {
    return InputFields.commonInputField(_nameController, "Name En*", (item) {
      return item.length > 0 ? null : "Enter name in English";
    }, TextInputType.text, 1);
  }

  Widget _titleArInputField() {
    return InputFields.commonInputField(_nameArController, "Name Ar*", (item) {
      return item.length > 0 ? null : "Enter name in Arabic";
    }, TextInputType.text, 1);
  }

  Widget _videoUrlInputField() {
    return InputFields.commonInputField(_videoUrlController, "Video URL",
        (item) {
      return item.length > 0 ? null : "Enter Video URL";
    }, TextInputType.text, 1);
  }

  Widget _minimumQuantityInputField() {
    return InputFields.onlyDigitInputField(_minQtyController, "Stock*", (item) {
      return item.length > 0 ? null : "Enter stock";
    }, TextInputType.number, 1);
  }

  Widget _unitPriceInputField() {
    return InputFields.commonInputField(_uPriceController, "Unit Price*",
        (item) {
      return item.length > 0 ? null : "Enter Unit Price";
    }, TextInputType.number, 1);
  }

  Widget _purchasePriceInputField() {
    return InputFields.commonInputField(_pPriceController, "Purchase Price*",
        (item) {
      return item.length > 0 ? null : "Enter Purchase Price";
    }, TextInputType.number, 1);
  }

  Widget _taxPriceInputField() {
    return InputFields.commonInputField(_taxController, "Tax*", (item) {
      return item.length > 0 ? null : "Enter Tax";
    }, TextInputType.text, 1);
  }

  Widget _discountInputField() {
    return InputFields.commonInputField(_discountController, "Discount",
        (item) {
      return item.length > 0 ? null : "Enter Discount";
    }, TextInputType.text, 1);
  }

  Widget _currentStockInputField() {
    return InputFields.commonInputField(
        _currentStockController, "Current Stock", (item) {
      return item.length > 0 ? null : "Enter Current Stock";
    }, TextInputType.number, 1);
  }

  Widget _detailInputField() {
    return InputFields.commonInputField(_detailController, "Detail En*",
        (item) {
      return item.length > 0 ? null : "Enter Detail in English";
    }, TextInputType.text, 3);
  }

  Widget _detailArInputField() {
    return InputFields.commonInputField(_detailArController, "Detail Ar*",
        (item) {
      return item.length > 0 ? null : "Enter Detail in Arabic";
    }, TextInputType.text, 3);
  }

  Widget _deniedNoteInputField() {
    return InputFields.commonInputField(_deniedNoteController, "Denied Note",
        (item) {
      return item.length > 0 ? null : "Enter Denied Note";
    }, TextInputType.text, 3);
  }

  _buildRefundableCheckedBox() {
    return CheckboxListTile(
      activeColor: primaryColor,
      title: Text(
        "Refundable",
      ),
      value: _isRefundable,
      onChanged: (newValue) {
        setState(() {
          _isRefundable = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  _buildFreeShippingCheckedBox() {
    return CheckboxListTile(
      activeColor: primaryColor,
      title: Text(
        "Free Shipping",
      ),
      value: _isFreeShipping,
      onChanged: (newValue) {
        setState(() {
          _isFreeShipping = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  _categoryDropDown() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: DropdownButton<String>(
          focusColor: Colors.white,
          value: _selectedCategory,
          //elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: btnColor,
          items: _categoryList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Select Category",
          ),
          onChanged: (String? value) {
            setState(() {
              _selectedCategories.add(
                  categories.firstWhere((element) => element.name == value));
              _selectedCategory = value;
            });
          },
        ),
      ),
    );
  }

  _taxTypeDropDown() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: DropdownButton<String>(
          focusColor: Colors.white,
          value: _selectedTaxType,
          //elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: btnColor,
          items: _taxTypeList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Tax Type",
          ),
          onChanged: (String? value) {
            setState(() {
              _selectedTaxType = value;
            });
          },
        ),
      ),
    );
  }

  _discountTypeDropDown() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: DropdownButton<String>(
          focusColor: Colors.white,
          value: _selectedDiscountType,
          //elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: btnColor,
          items:
              _discountTypeList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Discount Type",
          ),
          onChanged: (String? value) {
            setState(() {
              _selectedDiscountType = value;
            });
          },
        ),
      ),
    );
  }

  _statusDropDown() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: DropdownButton<String>(
          focusColor: Colors.white,
          value: _selectedStatus,
          //elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: btnColor,
          items: _statusList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Status",
          ),
          onChanged: (String? value) {
            setState(() {
              _selectedStatus = value;
            });
          },
        ),
      ),
    );
  }

  _updatedItem() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final name = _nameController.text;
    final qty = _minQtyController.text;
    final List<File> updateImages = [];
    for (var image in _photos) {
      if (image is File) {
        updateImages.add(image);
      }
    }
    final List<String> ids = _selectedCategories.map((e) => e.id).toList();
    final nameAr = _nameArController.text;
    final detailAr = _detailArController.text;
    final detail = _detailController.text;
    final price = _uPriceController.text;
    final response = await ItemService.updateData(name, qty, widget.item!.id,
        updateImages, ids, nameAr, detailAr, detail, price);
    if (response.toString().contains('success')) {
      // if (_sendNotification) {
      //   _handleSendNotification();
      // } else {
      ToastMsg.showToastMsg("Successfully added");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/ItemPage', ModalRoute.withName('/HomePage'));
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
      // }
    } else {
      log('add itemadd item: ' + response.toString());
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  void _addItem() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final name = _nameController.text;
    final qty = _minQtyController.text;
    final detail = _detailController.text;
    final price = _uPriceController.text;
    final nameAr = _nameArController.text;
    final detailAr = _detailArController.text;
    final List<File> updateImages = [];
    for (var image in _photos) {
      if (image is File) {
        updateImages.add(image);
      }
    }
    final List<String> ids = _selectedCategories.map((e) => e.id).toList();
    final uploadData = await ItemService.addData(
        name, qty, updateImages, ids, detail, price, nameAr, detailAr);
    if (uploadData.toString().contains("success")) {
      // if (_sendNotification) {
      //   _handleSendNotification();
      // } else {
      ToastMsg.showToastMsg("Successfully added");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/ItemPage', ModalRoute.withName('/HomePage'));
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
      // }
    } else {
      log('add item: ' + uploadData.toString());
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }

    //print("Updated $uploadData");
  }
}
