
class TestimonialsModel{
  var name;
  var description;
  var imageUrl;
  var id;


  TestimonialsModel({
    this.imageUrl,
    this.description,
    this.name,
    this.id


  });

  factory TestimonialsModel.fromJson(Map<String,dynamic> json){
    return TestimonialsModel(

      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      id: json['id'],

    );
  }

  Map<String, dynamic> toAddJson() {
    return {

      "name": this.name,
      "description": this.description,
      "imageUrl": this.imageUrl,

    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "name": this.name,
      "description": this.description,
      "imageUrl": this.imageUrl,
      "id":this.id
    };
  }

}