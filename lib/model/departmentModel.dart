class DepartmentModel{
  var id;
  var name;
  var imageUrl;
  var clinicId;
  var cityId;
  DepartmentModel({
    this.id,
    this.name,
    this.imageUrl,
    this.cityId,
    this.clinicId
  });
  factory DepartmentModel.fromJson(Map<String,dynamic> json){
    return DepartmentModel(
        id:json['id'].toString(),
        name:json['name'],
        imageUrl:json['imageUrl'],

    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      "name": this.name,
      "imageUrl": this.imageUrl,
      "cityId":this.cityId,
      "clinicId":this.clinicId

    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "name": this.name,
      "imageUrl": this.imageUrl,
      "id":this.id,
      "cityId":this.cityId,
      "clinicId":this.clinicId
    };
  }
}