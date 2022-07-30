
class NotificationModel{
  var body;
  var routeTo;
  var sendBy;
  var sendFrom;
  var sendTo;
  var title;
  var uId;
  var createdTimeStamp;
  var id;
  var status;
  var doctId;

  NotificationModel({
  this.body,
    this.title,
    this.uId,
    this.routeTo,
    this.sendTo,
    this.createdTimeStamp,
    this.sendBy,
    this.sendFrom,
    this.id,
    this.status,
    this.doctId
  });

  factory NotificationModel.fromJson(Map<String,dynamic> json){
    return NotificationModel(
      title:json['title'],
      body:json['body'],
      sendFrom:json['sendFrom'],
      sendBy:json['sendBy'],
      sendTo:json['sendTo'],
      routeTo:json['routeTo'],
      uId:json['uId'],
        createdTimeStamp:json['createdTimeStamp'],
      id: json['id'],
      status: "all"

    );
  }
  Map<String,dynamic> toJsonAddForAdmin(){
    return {
      "title":this.title,
      "body":this.body,
      "sendBy":this.sendBy,
      "uId":this.uId
    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "title":this.title,
      "body":this.body,
      "sendFrom":this.sendFrom,
      "sendBy":this.sendBy,
      "sendTo":this.sendTo,
      "routeTo":this.routeTo,
      "uId":this.uId
    };

  }
}