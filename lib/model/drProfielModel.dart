
class DrProfileModel {
  var firstName;
  var lastName;
  var email;
  var pNo1;
  var pNo2;
  var description;
  var whatsAppNo;
  var subTitle;
  var profileImageUrl;
  var address;
  var aboutUs;
  var fdmId;
  var deptId;
  var hName;

  var id;
  var lunchOpeningTime;
  var lunchClosingTime;
  var closingDate;
  var opt;
  var clt;
  var dayCode;
  var serviceTime;
  var stopBooking;
  var fee;
  var clinicId;
  var cityId;
  var pass;
  var clinicName;


  DrProfileModel({
    this.firstName,
    this.lastName,
    this.email,
    this.pNo1,
    this.pNo2,
    this.description,
    this.whatsAppNo,
    this.subTitle,
    this.profileImageUrl,
    this.address,
    this.aboutUs,
    this.fdmId,
    this.deptId,
    this.hName,
    this.id,
    this.lunchOpeningTime,
    this.lunchClosingTime,
    this.closingDate,
    this.dayCode,
    this.clt,
    this.opt,
    this.serviceTime,
    this.stopBooking,
    this.fee,
    this.clinicId,
    this.cityId,
    this.pass,
    this.clinicName
  });

  factory DrProfileModel.fromJson(Map<String, dynamic> json){
    return DrProfileModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        pNo1: json['pNo1'],
        pNo2: json['pNo2'],
        email: json['email'],
        subTitle: json['subTitle'],
        description: json['description'],
        whatsAppNo: json['whatsAppNo'],
        profileImageUrl: json['profileImageUrl'],
        address: json['address'],
        aboutUs: json['aboutUs'],
        fdmId: json['fcmId'],
        deptId: json['deptId'],
        cityId:json['city_id'] ,
        clinicId: json['clinic_id'],
        hName: json['hName'],
        id: json['id'].toString(),
        lunchClosingTime: json["lct"],
        lunchOpeningTime: json['lot'],
        closingDate: json['closingDate'],
        opt: json["opt"],
        clt: json['clt'],
        dayCode: json['dayCode'],
        serviceTime:json['timeInt'],
        stopBooking: json['stopBooking'],
      fee: json['fee'],
      pass: json['pass'],
      clinicName: json['title']==null?"":json['title']

    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "pNo1": this.pNo1,
      "pNo2": this.pNo2,
      "description": this.description,
      "whatsAppNo": this.whatsAppNo,
      "subTitle": this.subTitle,
      "profileImageUrl": this.profileImageUrl,
      "address": this.address,
      "aboutUs": this.aboutUs,
      "id": this.id,
      "hName":this.hName,
      "lot":this.lunchOpeningTime,
      "lct":this.lunchClosingTime,
      "deptId":this.deptId,
      "stopBooking":this.stopBooking,
      "opt":this.opt,
      "clt":this.clt,
      "dayCode":this.dayCode,
      "serviceTime":this.serviceTime,
      "fee":this.fee,
      "pass":this.pass,
    };
  }
  Map<String, dynamic> toUpdateAboutJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "pNo1": this.pNo1,
      "pNo2": this.pNo2,
      "description": this.description,
      "whatsAppNo": this.whatsAppNo,
      "subTitle": this.subTitle,
      "profileImageUrl": this.profileImageUrl,
      "address": this.address,
      "aboutUs": this.aboutUs,
      "id": this.id,


    };
  }
  Map<String, dynamic> toAddJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "pNo1": this.pNo1,
      "pNo2": this.pNo2,
      "description": this.description,
      "whatsAppNo": this.whatsAppNo,
      "subTitle": this.subTitle,
      "profileImageUrl": this.profileImageUrl,
      "address": this.address,
      "aboutUs": this.aboutUs,
      "hName":this.hName,
      "lot":this.lunchOpeningTime,
      "lct":this.lunchClosingTime,
      "deptId":this.deptId,
      "stopBooking":this.stopBooking,
      "opt":this.opt,
      "clt":this.clt,
      "dayCode":this.dayCode,
      "serviceTime":this.serviceTime,
      "fee":this.fee,
      "cityId":this.cityId,
      "clinicId":this.clinicId,
      "pass":this.pass,
    };
  }
}