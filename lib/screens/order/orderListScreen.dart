import 'dart:developer';

import 'package:demoadmin/screens/order_detail/order_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/orderModel.dart';
import '../../utilities/colors.dart';
import '../../widgets/errorWidget.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/noDataWidget.dart';
import 'orderViewModel.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with SingleTickerProviderStateMixin {
  RefreshController _refreshprocessingController =
      RefreshController(initialRefresh: false);
  RefreshController _refreshApproviedController =
      RefreshController(initialRefresh: false);

      RefreshController _refreshdeliveredController =
      RefreshController(initialRefresh: false);

      RefreshController _refreshcanceledController =
      RefreshController(initialRefresh: false);
  int page = 1;
  late TabController _controller;

  List<Widget> list = [
    Tab(icon: Text('processing')),
    Tab(icon: Text('Approved')),
    Tab(icon: Text('delivered')),
    Tab(icon: Text('canceled')),
  ];

  void _onRefresh(String status) async {
    page = 1;
    Provider.of<OrderViewModel>(context, listen: false)
        .getOrdreList(page, status);
        status == 'approved'
                        ? _refreshApproviedController.refreshCompleted()
                        : status == 'delivered' ? _refreshdeliveredController.refreshCompleted()
                        : status == 'processing' ? _refreshprocessingController.refreshCompleted()
                        : _refreshcanceledController.refreshCompleted();
  }

  void _onLoading(String status) async {
    page = page + 1;
    Provider.of<OrderViewModel>(context, listen: false)
        .getOrdreList(page, status);
        status == 'approved'
                        ? _refreshApproviedController.refreshCompleted()
                        : status == 'delivered' ? _refreshdeliveredController.refreshCompleted()
                        : status == 'processing' ? _refreshprocessingController.refreshCompleted()
                        : _refreshcanceledController.refreshCompleted();
  }

  @override
  void initState() {
    Provider.of<OrderViewModel>(context, listen: false)
        .getOrdreList(page, 'approved');
    Provider.of<OrderViewModel>(context, listen: false)
        .getOrdreList(page, 'processing');
        Provider.of<OrderViewModel>(context, listen: false)
        .getOrdreList(page, 'delivered');
        Provider.of<OrderViewModel>(context, listen: false)
        .getOrdreList(page, 'canceled');
    _controller = TabController(length: list.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        backgroundColor: btnColor,
        bottom: TabBar(
          isScrollable: true,
          tabs: list,
          controller: _controller,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          _buildBody(_refreshprocessingController, 'processing'),
          _buildBody(_refreshApproviedController, 'approved'),
          _buildBody(_refreshdeliveredController, 'delivered'),
          _buildBody(_refreshcanceledController, 'canceled'),
          // Text('test')
        ],
      ),
    );
  }

  Container _buildBody(RefreshController controller, String status) {
    final model = Provider.of<OrderViewModel>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            onRefresh: () => _onRefresh(status),
            onLoading: () => _onLoading(status),
            controller: controller,
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                if (model.isNoMoreData) {
                  body = Text("No more Data");
                } else if (mode == LoadStatus.idle) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: model.loading ? LoadingIndicatorWidget()
                : _isEmpty(status, model)
                    ? NoDataWidget()
                    : model.isError
                        ? IErrorWidget()
                : ListView.builder(
                    itemCount: status == 'approved'
                        ? model.approvedOrders.length
                        : status == 'delivered' ? model.deliveredOrders.length 
                        : status == 'processing' ? model.processingOrders.length 
                        : model.canceledOrders.length,
                    itemBuilder: (context, index) => _buildListTail(
                        status == 'approved'
                        ? model.approvedOrders[index]
                        : status == 'delivered' ? model.deliveredOrders[index] 
                        : status == 'processing' ? model.processingOrders[index] 
                        : model.canceledOrders[index],
                        model,
                        index,
                        status)),
          )),
    );
  }

  Widget _buildListTail(OrderModel order, OrderViewModel model, int i, String status) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order))),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 5, right: 5, top: 0),
            // leading: _imageBox(thumbnail),
    
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Number: ${order.id}',
                  style: TextStyle(
                    fontFamily: 'OpenSans-SemiBold',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Amount: ${order.orderAmount}"),
                  Row(
                    children: [
                      Container(
                          height: 10,
                          width: 10,
                          color: order.paymentMethod != null &&
                                  order.paymentMethod != "COD" &&
                                  order.paymentMethod != ""
                              ? Colors.green
                              : Colors.red),
                      SizedBox(width: 10),
                      Text(order.paymentMethod != null &&
                              order.paymentMethod != "COD" &&
                              order.paymentMethod != ""
                          ? "Online payment"
                          : "Cash On delivery"),
                      //
                    ],
                  ),
                  SizedBox(height: 15),
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // width: MediaQuery.of(context).size.width * .2,
                        child: Text(
                          order.createdAt.toString(),
                          maxLines: 2,
                          style: TextStyle(color: Colors.grey[500], fontSize: 14),
                        ),
                      ))
                ]),
                InkWell(
                  // onTap: () {
                  //   status == 'approved'
                  //       ? null
                  //       : model.updateStatus(order.id, 'approved', i);
                  // },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      // border: Border.all(color: btnColor),
                    ),
                    child: model.approvedIndex == i &&
                            model.statusState == StatusState.loading
                        ? LoadingIndicatorWidget()
                        : Text(
                            status,
                            style: TextStyle(
                                color: Colors.white),
                          ),
                  ),
                )
              ],
            ),
            //  isThreeLine: true,
          ),
          Divider(),
        ],
      ),
    );
  }

  _isEmpty(String status, OrderViewModel  model) {
    if (status == 'approved') {
      return model.approvedOrders.length <= 0 ? true : false;
    } else if (status == 'delivered') {
      return model.deliveredOrders.length <= 0 ? true : false;
    } else if (status == 'processing') {
      return model.processingOrders.length <= 0 ? true : false;
    } else if (status == 'canceled') {
      return model.canceledOrders.length <= 0 ? true : false;
    }
  }

  _getStatusColor (String status) {
    if (status == 'approved') {
      return btnColor;
    } else if (status == 'delivered') {
      return Colors.grey;
    } else if (status == 'processing') {
      return Colors.orange[200];
    } else if (status == 'canceled') {
      return Colors.red;
    }
  }
}
