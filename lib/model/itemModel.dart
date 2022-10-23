// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

List<ItemModel> itemModelFromJson(String str) =>
    List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  ItemModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.quantity,
    this.images,
    this.itemDetailsEn,
    this.itemDetailsAr,
    this.categoryIds,
    this.sharePrice,
  });

  String id;
  String name;
  String nameAr;
  String? quantity;
  String? itemDetailsEn;
  String? itemDetailsAr;
  String? sharePrice;
  List<String>? images;
  List<String>? categoryIds;

  ItemModel copyWith({
    required String id,
    required String name,
    String? quantity,
    List<String>? images,
    String? itemDetailsEn,
    String? itemDetailsAr,
    String? sharePrice,
    List<String>? categoryIds,
  }) =>
      ItemModel(
        id: id,
        name: name,
        nameAr: nameAr,
        quantity: quantity ?? this.quantity,
        itemDetailsEn: itemDetailsEn ?? this.itemDetailsEn,
        itemDetailsAr: itemDetailsAr ?? this.itemDetailsAr,
        images: images ?? this.images,
        sharePrice: sharePrice ?? this.sharePrice,
        categoryIds: categoryIds ?? this.categoryIds,
      );

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name_en"] == null ? null : json["name_en"],
        nameAr: json["name_ar"] == null ? null : json["name_ar"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        itemDetailsEn:
            json["item_details_en"] == null ? null : json["item_details_en"],
        itemDetailsAr:
            json["item_details_ar"] == null ? null : json["item_details_ar"],
        sharePrice: json["share_price"] == null ? null : json["share_price"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        categoryIds: json["category_ids"] == null
            ? null
            : List<String>.from(json["category_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name_ar": nameAr == null ? null : nameAr,
        "name_en": name == null ? null : name,
        "quantity": quantity == null ? null : quantity,
        "item_details_en": itemDetailsEn == null ? null : itemDetailsEn,
        "item_details_ar": itemDetailsAr == null ? null : itemDetailsAr,
        "share_price": sharePrice == null ? null : sharePrice,
        "images":
            images == null ? null : List<dynamic>.from(images!.map((x) => x)),
        "category_ids": categoryIds == null
            ? null
            : List<dynamic>.from(categoryIds!.map((x) => x)),
      };
}
