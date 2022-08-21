
class GalleryModel{

  var imageUrl;
  var id;


  GalleryModel({
    this.imageUrl,
    this.id

  });

  factory GalleryModel.fromJson(Map<String,dynamic> json){
    return GalleryModel(
      imageUrl: json['imageUrl'],
      id:json['id']

    );
  }
  Map<String, dynamic> toAddJson() {
    return {
      "imageUrl": this.imageUrl
    };
  }

}