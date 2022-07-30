
class ClinicModel {
  var id;
  var title;
  var imageUrl;
  var location;
  var cityId;
  var locationName;
  var number_reveal;

  ClinicModel({
    this.id,
    this.title,
    this.imageUrl,
    this.location,
    this.locationName,
    this.cityId,
    this.number_reveal
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json){
    return ClinicModel(
      locationName: json['location_name'],
        imageUrl: json['imageUrl'],
        location: json['location'],
        title: json['title'],
        number_reveal: json['number_reveal'],
        id: json['id'].toString(),
    );
  }
   Map<String, dynamic> toAddJson() {
    return {
      "name": this.title,
      "imageUrl": this.imageUrl,
      "cityId":this.cityId,
      "gUrl":this.location,
      "lName":this.locationName,
      "number_reveal":this.number_reveal
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "name": this.title,
      "imageUrl": this.imageUrl,
      "id":this.id,
      "gUrl":this.location,
      "cityId":this.cityId,
      "number_reveal":this.number_reveal

    };
  }

}