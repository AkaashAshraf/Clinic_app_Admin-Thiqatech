
class BannerImageModel{
  var banner1;
  var banner2;
  var banner3;
  var banner4;
  var clinicImage;
  var id;

  BannerImageModel({
    this.banner1,
    this.banner2,
    this.banner3,
    this.banner4,
    this.clinicImage,
    this.id

  });

  factory BannerImageModel.fromJson(Map<String,dynamic> json){
    return BannerImageModel(

      banner1: json['banner1'],
      banner2: json['banner2'],
      banner3: json['banner3'],
      banner4: json['banner4'],
      clinicImage: json['clinicImage'],
      id:json['id']

    );
  }


}