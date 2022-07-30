
class CityModel {
  var id;
  var title;
  var imageUrl;


  CityModel({
    this.id,
    this.title,
    this.imageUrl,
  });

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
      imageUrl: json['imageUrl'],
      title: json['cityName'],
      id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      "name": this.title,
      "imageUrl": this.imageUrl,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "name": this.title,
      "imageUrl": this.imageUrl,
      "id":this.id,
    };
  }
}