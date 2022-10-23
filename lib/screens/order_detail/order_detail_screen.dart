import 'dart:developer';

import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/orderModel.dart';
import 'package:demoadmin/screens/order/orderListScreen.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../service/orderService.dart';
import '../../widgets/imageWidget.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String? _status;
  bool _loading = false;

  @override
  void initState() {
    _status = widget.order.orderStatus ?? 'approved';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Detail'),
          backgroundColor: btnColor,
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(color: btnColor),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.separated(
                          itemCount:
                              widget.order.orderDetails!.itemDetails.length,
                          separatorBuilder: (context, _) => SizedBox(
                            height: 8,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            log('userId: ${widget.order.userId}');
                            final item =
                                widget.order.orderDetails!.itemDetails[index];
                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                    color: Colors.black.withOpacity(.3)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: item.images == null ||
                                              item.images!.length < 1
                                          ? SizedBox(
                                              height: 60,
                                              child: Image.asset(
                                                  'assets/icons/offline.png'))
                                          : SizedBox(
                                              height: 60,
                                              child: Image.network(
                                                  imageUrl + item.images![0])),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${item.name}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          // Text(
                                          //   order.orderDetails.price + ' OMR',
                                          //   style: TextStyle(
                                          //       fontSize: 15, color: Colors.grey[700]),
                                          // ),
                                          Text(
                                            'Quantity - ' + item.quantity!,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      )),
                  Expanded(
                      flex: 7,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                        width: double.infinity,
                        // color: appBarColor,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 10,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 7), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Info',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Order Number - ' +
                                      widget.order.orderDetails!.orderId,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      SizedBox(height: 4),
                                      Text(
                                        'Order Price: ' +
                                            widget.order.orderAmount +
                                            " OMR",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Payment Method:  " +
                                            "${widget.order.paymentMethod ?? ''}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 4, child: _buildDropDown()),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'User Info',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'User Name - ' +
                                  '${widget.order.userDetails.firstName} ${widget.order.userDetails.lastName} ',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Phone Number - ' +
                                  '${widget.order.userDetails.pNo}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'User city - ' +
                                  '${widget.order.userDetails.city}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 12),
                            Spacer(),
                            Text(
                              "Note: ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .13,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  widget.order.orderNote ?? '',
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                _updateStatus(_status ?? 'pending');
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: appBarColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ));
  }

  Widget _buildDropDown() {
    return CustomDropdown(
        items: ['approved', 'delivered', 'processing', 'canceled'],
        hint: 'Change Status',
        value: _status!,
        onChange: (value) {
          setState(() {
            _status = value;
          });
        });
  }

  Widget imageBox(String imageUrl) {
    return Container(
        width: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ImageBoxFillWidget(imageUrl: imageUrl),
        ));
  }

  _updateStatus(String orderStatus) async {
    setState(() {
      _loading = true;
    });
    try {
      final res = await OrderService.updateStatus(
          widget.order.orderDetails!.orderId, orderStatus);
      if (res == 'success') {
        // _state = StatusState.loaded;
        Fluttertoast.showToast(
            msg: "Status change successfully to " + orderStatus,
            toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OrderListScreen()));
      } else {
        // _state = StatusState.error;
        Fluttertoast.showToast(
            msg: "Something wrong", toastLength: Toast.LENGTH_SHORT);
      }
      setState(() {
        _loading = false;
      });
      // notifyListeners();
    } catch (e) {
      log('order', name: 'update status', error: e.toString());
      // _state = StatusState.error;
      Fluttertoast.showToast(
          msg: "Something wrong", toastLength: Toast.LENGTH_SHORT);
      // notifyListeners();
      setState(() {
        _loading = false;
      });
    }
  }
}
