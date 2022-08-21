import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/orderModel.dart';
import '../../service/orderService.dart';

class OrderViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  bool _isEmpty = false;
  bool get isEmpty => _isEmpty;

  bool _isError = false;
  bool get isError => _isError;

  bool _isNoMoreData = false;
  bool get isNoMoreData => _isNoMoreData;

  int approvedIndex = 10000;

  StatusState? _state;
  StatusState? get statusState => _state;

  List<OrderModel> _processingOrders = [];
  List<OrderModel> get processingOrders => _processingOrders.reversed.toList();

  List<OrderModel> _deliveredOrders = [];
  List<OrderModel> get deliveredOrders => _deliveredOrders.reversed.toList();

  List<OrderModel> _canceledOrders = [];
  List<OrderModel> get canceledOrders => _canceledOrders.reversed.toList();

  List<OrderModel> _approvedOrders = [];
  List<OrderModel> get approvedOrders => _approvedOrders.reversed.toList();

  updateStatus(String orderId, String orderStatus, int i) async {
    approvedIndex = i;
    _state = StatusState.loading;
    notifyListeners();
    try {
      final res = await OrderService.updateStatus(orderId, orderStatus);
      if (res == 'success') {
        _state = StatusState.loaded;
        Fluttertoast.showToast(
            msg: "Approved", toastLength: Toast.LENGTH_SHORT);
        Future.delayed(Duration(milliseconds: 100), () {
          getOrdreList(1, 'pending');
        });
      } else {
        _state = StatusState.error;
        Fluttertoast.showToast(
            msg: "Something wrong", toastLength: Toast.LENGTH_SHORT);
      }
      notifyListeners();
    } catch (e) {
      log('order', name: 'update status', error: e.toString());
      _state = StatusState.error;
      Fluttertoast.showToast(
          msg: "Something wrong", toastLength: Toast.LENGTH_SHORT);
      notifyListeners();
    }
  }

  getOrdreList(int page, String status) async {
    _loading = true;
     notifyListeners();
    if (page == 1) {
     
      status == 'processing'
          ? _processingOrders = []
          : status == 'delivered'
              ? _deliveredOrders = []
              : status == 'approved'
                  ? _approvedOrders = []
                  : status == 'canceled'
                      ? _canceledOrders = []
                      : null;

      notifyListeners();
    }
    try {
      final orders = await OrderService.getData(page.toString(), status);
      _isNoMoreData = orders.isEmpty ? true : false;
      status == 'approved'
          ? _approvedOrders.addAll(orders) 
          : status == 'processing' ? _processingOrders.addAll(orders) :
          status == 'delivered' ? _deliveredOrders.addAll(orders) :
           _canceledOrders.addAll(orders) ;
      //  if (_pandingOrders.length < 1) {
      //    _isEmpty = true;
      //  }
      // log('approved list ' + _pandingOrders.toString());
      _loading = false;
      notifyListeners();
    } catch (e) {
      log('Order List', name: 'Order list error', error: e.toString());
      _isError = true;
      _loading = false;
      notifyListeners();
    }
  }
}

// ['approved', 'delivered', 'processing', 'canceled'],
enum StatusState { loading, loaded, error }
