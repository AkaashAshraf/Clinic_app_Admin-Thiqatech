

class AppointmentTypeModel{
  String? id;
  String? titleEn;
  String? titleAr;
  String? imageUrl;
  String? forTimeMin;
  String? subTitleEn;
  String? subTitleAr;
  String? openingTime;
  String? closingTime;
  String? day;
  String? charges;
  String? doctId;



  AppointmentTypeModel({
    this.titleEn,
    this.titleAr,
    this.imageUrl,
    this.forTimeMin,
    this.id,
    this.subTitleEn,
    this.subTitleAr,
    this.openingTime,
    this.closingTime,
    this.day,
    this.doctId,
    this.charges
  });

  factory AppointmentTypeModel.fromJson(Map<String,dynamic> json){
    return AppointmentTypeModel(
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      imageUrl: json['imageUrl'],
      forTimeMin:  json['forTimeMin'],
        id: json['id'],
        subTitleEn:json['subTitle_en'],
        subTitleAr:json['subTitle_ar'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      day: json['day'],
      doctId: json['doctId'],
      charges: json['charges'],
    );
  }
  Map<String, dynamic> toAddJson() {
    return {
      "title_en": this.titleEn,
      "title_ar": this.titleAr,
      "forTimeMin": (this.forTimeMin).toString(),
      "imageUrl": this.imageUrl,
      "subTitle_en":this.subTitleEn,
      "subTitle_ar":this.subTitleAr,
      "openingTime":this.openingTime,
      "closingTime":this.closingTime,
      "day":this.day,
      "charges": this.charges,
      // "doctId": this.doctId,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "title_en": this.titleEn,
      "title_ar": this.titleAr,
      "forTimeMin": (this.forTimeMin).toString(),
      "imageUrl": this.imageUrl,
      "id":this.id,
      "subTitle_en":this.subTitleEn,
      "subTitle_ar":this.subTitleAr,
      "openingTime":this.openingTime,
      "closingTime":this.closingTime,
      "day":this.day,
      "charges": this.charges,
      // "doctId": this.doctId,
    };
  }

}