import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/orderModel.dart';

class OrderService {
  static const _viewUrl = "$apiUrl/get_orders";
  static const _updateStatus = "$apiUrl/update_order_status";
  static List<OrderModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<OrderModel>.from(data.map((item) => OrderModel.fromJson(item)));
  }

  static updateStatus(String orderId, String orderStatus) async {
    log('response erro'+orderId + orderStatus);
    final response = await http.post(Uri.parse(_updateStatus), body: {
      'order_id': orderId,
      'order_status': orderStatus,
    });
    log('response erro'+response.body.toString());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'error';
    }
  }

  static Future<List<OrderModel>> getData(String page, String status) async {
    
    final response = await http.post(Uri.parse("$_viewUrl"), body: {
      'page_no': page,
      'order_status': status,
    });
    log("${response.statusCode}");
    if (response.statusCode == 200) {
      List<OrderModel> list = dataFromJson(response.body);
      log(list.toString());
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
