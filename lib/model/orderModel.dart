// // To parse this JSON data, do
// //
// //     final orderModel = orderModelFromJson(jsonString);

// class OrderModel {
//     OrderModel({
//         required this.id,
//         this.userId,
//         required this.userDetails,
//         required this.orderAmount,
//         this.orderNote,
//         required this.paymentMethod,
//         required this.createdAt,
//         required this.orderDetails,
//         this.orderStatus,
//     });

//     String id;
//     String? userId;
//     List<UserDetail>? userDetails;
//     String orderAmount;
//     String? orderNote;
//     String paymentMethod;
//     dynamic createdAt;
//     String? orderStatus;
//     OrderDetailsClass orderDetails;

//     factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
//         id: json["id"] == null ? null : json["id"],
//         userId: json["user_id"] == null ? null : json["user_id"],
//         userDetails: json["user_details"] == null ? null : List<UserDetail>.from(json["user_details"].map((x) => UserDetail.fromJson(x))),
//         orderAmount: json["order_amount"] == null ? null : json["order_amount"],
//         orderNote: json["order_note"] == null ? null : json["order_note"],
//         paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
//         createdAt: json["created_at"],
//         orderStatus: json['order_status'] == null ? null : json['order_status'],
//         orderDetails: OrderDetailsClass.fromJson(json["order_details"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "user_id": userId == null ? null : userId,
//         "user_details": userDetails == null ? null : List<dynamic>.from(userDetails!.map((x) => x.toJson())),
//         "order_amount": orderAmount == null ? null : orderAmount,
//         "order_note": orderNote == null ? null : orderNote,
//         "payment_method": paymentMethod == null ? null : paymentMethod,
//         "created_at": createdAt,
//         "order_status": orderStatus,
//          "order_details": orderDetails.toJson(),
//     };
// }

// class OrderDetailsClass {
//     OrderDetailsClass({
//         required this.orderId,
//         required this.itemId,
//         this.itemDetails,
//         required this.qty,
//         required this.price,
//     });

//     String orderId;
//     String itemId;
//     List<ItemDetail>? itemDetails;
//     String qty;
//     String price;

//     factory OrderDetailsClass.fromJson(Map<String, dynamic> json) => OrderDetailsClass(
//         orderId: json["order_id"] == null ? null : json["order_id"],
//         itemId: json["item_id"] == null ? null : json["item_id"],
//         itemDetails: json["item_details"] == null ? null : List<ItemDetail>.from(json["item_details"].map((x) => ItemDetail.fromJson(x))),
//         qty: json["qty"] == null ? null : json["qty"],
//         price: json["price"] == null ? null : json["price"],
//     );

//     Map<String, dynamic> toJson() => {
//         "order_id": orderId == null ? null : orderId,
//         "item_id": itemId == null ? null : itemId,
//         "item_details": itemDetails == null ? null : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
//         "qty": qty == null ? null : qty,
//         "price": price == null ? null : price,
//     };
// }

// class ItemDetail {
//     ItemDetail({
//         required this.id,
//         required this.name,
//         required this.quantity,
//         this.images,
//         this.categoryIds,
//     });

//     String id;
//     String name;
//     String quantity;
//     List<String>? images;
//     List<String>? categoryIds;

//     factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         quantity: json["quantity"] == null ? null : json["quantity"],
//         images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
//         categoryIds: json["category_ids"] == null ? null : List<String>.from(json["category_ids"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "quantity": quantity == null ? null : quantity,
//         "images": images == null ? null : List<dynamic>.from(images!.map((x) => x)),
//         "category_ids": categoryIds == null ? null : List<dynamic>.from(categoryIds!.map((x) => x)),
//     };
// }





// class UserDetail {
//     UserDetail({
//         required this.id,
//         required this.firstName,
//         required this.lastName,
//         this.uId,
//         this.city,
//         this.email,
//         this.fcmId,
//         this.imageUrl,
//         this.pNo,
//         this.searchByName,
//         required this.createdTimeStamp,
//         required this.updatedTimeStamp,
//         this.age,
//         this.gender,
//     });

//     String id;
//     String firstName;
//     String lastName;
//     dynamic uId;
//     String? city;
//     String? email;
//     String? fcmId;
//     String? imageUrl;
//     String? pNo;
//     dynamic searchByName;
//     DateTime createdTimeStamp;
//     DateTime updatedTimeStamp;
//     String? age;
//     dynamic gender;

//     factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
//         id: json["id"] == null ? null : json["id"],
//         firstName: json["firstName"] == null ? null : json["firstName"],
//         lastName: json["lastName"] == null ? null : json["lastName"],
//         uId: json["uId"] == null ? null : json["uId"],
//         city: json["city"] == null ? null : json["city"],
//         email: json["email"] == null ? null : json["email"],
//         fcmId: json["fcmId"] == null ? null : json["fcmId"],
//         imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
//         pNo: json["pNo"] == null ? null : json["pNo"],
//         searchByName: json["searchByName"] == null ? null : json["searchByName"],
//         createdTimeStamp:  DateTime.parse(json["createdTimeStamp"]),
//         updatedTimeStamp:  DateTime.parse(json["updatedTimeStamp"]),
//         age: json["age"] == null ? null : json["age"],
//         gender: json["gender"] == null ? null : json["gender"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "firstName": firstName == null ? null : firstName,
//         "lastName": lastName == null ? null : lastName,
//         "uId": uId == null ? null : uId,
//         "city": city == null ? null : city,
//         "email": email == null ? null : email,
//         "fcmId": fcmId == null ? null : fcmId,
//         "imageUrl": imageUrl == null ? null : imageUrl,
//         "pNo": pNo == null ? null : pNo,
//         "searchByName": searchByName == null ? null : searchByName,
//         "createdTimeStamp": createdTimeStamp == null ? null : createdTimeStamp.toIso8601String(),
//         "updatedTimeStamp": updatedTimeStamp == null ? null : updatedTimeStamp.toIso8601String(),
//         "age": age == null ? null : age,
//         "gender": gender == null ? null : gender,
//     };
// }



// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

// import 'dart:convert';

// List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

// String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
    OrderModel({
        this.totalPages,
        required this.id,
        required this.userId,
        required this.userDetails,
        required this.orderAmount,
        this.orderNote,
        this.orderStatus,
        this.paymentMethod,
        this.transactionId,
        required this.createdAt,
        this.orderDetails,
    });

    int? totalPages;
    String id;
    String userId;
    UserDetails userDetails;
    String orderAmount;
    String? orderNote;
    String? orderStatus;
    String? paymentMethod;
    String? transactionId;
    DateTime createdAt;
    OrderDetails? orderDetails;

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
        id: json["id"],
        userId: json["user_id"],
        userDetails: UserDetails.fromJson(json["user_details"]),
        orderAmount: json["order_amount"],
        orderNote: json["order_note"],
        orderStatus: json["order_status"],
        paymentMethod: json["payment_method"],
        transactionId: json["transaction_id"],
        createdAt: DateTime.parse(json["created_at"]),
        orderDetails: OrderDetails.fromJson(json["order_details"]),
    );

    Map<String, dynamic> toJson() => {
        "total_pages": totalPages == null ? null : totalPages,
        "id": id,
        "user_id": userId,
        "user_details": userDetails.toJson(),
        "order_amount": orderAmount,
        "order_note": orderNote,
        "order_status": orderStatus,
        "payment_method": paymentMethod,
        "transaction_id": transactionId,
        "created_at": createdAt.toIso8601String(),
        "order_details": orderDetails!.toJson(),
    };
}

class OrderDetails {
    OrderDetails({
        required this.orderId,
        this.itemId,
        required this.itemDetails,
        this.qty,
        this.price,
    });

    String orderId;
    String? itemId;
    List<ItemDetail> itemDetails;
    String? qty;
    String? price;

    factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        orderId: json["order_id"],
        itemId: json["item_id"],
        itemDetails: List<ItemDetail>.from(json["item_details"].map((x) => ItemDetail.fromJson(x))),
        qty: json["qty"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "item_id": itemId,
        "item_details": List<dynamic>.from(itemDetails.map((x) => x.toJson())),
        "qty": qty,
        "price": price,
    };
}

class ItemDetail {
    ItemDetail({
        required this.id,
        this.name,
        this.quantity,
        this.images,
        this.categoryIds,
    });

    String id;
    String? name;
    String? quantity;
    List<String>? images;
    List<String>? categoryIds;

    factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        id: json["id"],
        name: json["name_en"],
        quantity: json["quantity"],
        images: List<String>.from(json["images"].map((x) => x)),
        categoryIds: List<String>.from(json["category_ids"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "category_ids": List<dynamic>.from(categoryIds!.map((x) => x)),
    };
}

class UserDetails {
    UserDetails({
        required this.id,
        this.firstName,
        this.lastName,
        this.city,
        this.email,
        this.imageUrl,
        this.pNo,
        this.gender,
        this.age,
    });

    String id;
    String? firstName;
    String? lastName;
    String? city;
    String? email;
    String? imageUrl;
    String? pNo;
    String? gender;
    String? age;

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        city: json["city"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        pNo: json["pNo"],
        gender: json["gender"],
        age: json["age"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "city": city,
        "email": email,
        "imageUrl": imageUrl,
        "pNo": pNo,
        "gender": gender,
        "age": age,
    };
}

