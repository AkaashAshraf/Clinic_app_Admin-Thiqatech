
class BlogPostModel {
  var body;
  var title;
 var createdTimeStamp;
  var updatedTimeStamp;
   var thumbImageUrl;
   var status;
   var id;
   var fileName;


  BlogPostModel({
    this.body,
    this.title,
    this.createdTimeStamp,
    this.updatedTimeStamp,
    this.thumbImageUrl,
    this.status,
    this.id,
    this.fileName
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json){
    return BlogPostModel(

        body: json['body'],
        createdTimeStamp: json['createdTimeStamp'],
        updatedTimeStamp: json['updatedTimeStamp'],
        title: json['title'],
      thumbImageUrl: json['thumbImageUrl'],
      id: json['id'],
      status: json['status'],
        fileName: json['fileName']


    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      "body": this.body,
      "title":this.title,
      "thumbImageUrl":this.thumbImageUrl,
      "status":this.status

    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "body": this.body,
      "title":this.title,
      "thumbImageUrl":this.thumbImageUrl,
      "status":this.status,
      "id":this.id,
      "fileName":this.fileName

    };
  }
}