
class ServiceModel {
  var title;
  var subTitle;
  var imageUrl;
  var id;
  var desc;
  var url;

  ServiceModel({
    this.title,
    this.subTitle,
    this.imageUrl,
    this.id,
    this.desc,
    this.url
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json){
    return ServiceModel(
      title: json['title'],
      subTitle: json['subTitle'],
      imageUrl: json['imageUrl'],
      id: json['id'],
      desc: json['description'],
      url: json['url']
    );
  }

 Map<String, dynamic> toAddJson() {
    return {
      "title": this.title,
      "subTitle": this.subTitle,
      "imageUrl": this.imageUrl,
      "description":this.desc,
      "url":this.url
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "title": this.title,
      "subTitle": this.subTitle,
      "imageUrl": this.imageUrl,
      "id":this.id,
      "description":this.desc,
      "url":this.url
    };
  }
}