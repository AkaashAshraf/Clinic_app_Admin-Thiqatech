
class FeedbackModel{
  var uid;
  var name;
  var phn;
  var feedbacktext;
  var date;

  FeedbackModel({
    this.uid,
    this.phn,
    this.name,
    this.feedbacktext,
    this.date
  });
  factory FeedbackModel.fromJson(Map<String, dynamic> json){
    return FeedbackModel(
        uid: json['uid'],
        name: json['name'],
        phn: json['phn'],
        feedbacktext: json['feedback_text'],
        date: json['created_time_stamp'],
    );
  }

  Map<String,dynamic>addJson(){
    return {
      "uid":this.uid,
      "name":this.name,
      "phn":this.phn,
      "feedback_text":this.feedbacktext

    };

  }

}