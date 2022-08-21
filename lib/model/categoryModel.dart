// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.icon,
    this.parentId,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.homeStatus,
    required this.nameAr,
  });

  String id;
  String name;
  dynamic slug;
  dynamic icon;
  dynamic parentId;
  dynamic position;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic homeStatus;
  String nameAr;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name_en"] == null ? null : json["name_en"],
    slug: json["slug"],
    icon: json["icon"],
    parentId: json["parent_id"],
    position: json["position"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    homeStatus: json["home_status"],
    nameAr: json['name_ar']
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name_en": name == null ? null : name,
    "slug": slug,
    "icon": icon,
    "parent_id": parentId,
    "position": position,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "home_status": homeStatus,
    'name_ar': name == null ? null : name,
  };
}
