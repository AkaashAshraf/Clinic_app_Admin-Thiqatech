

class ClosingDateModel{
  var date;
  var id;
  var allDay;
  List? blockTime=[];


  ClosingDateModel({
    this.id,
    this.date,
    this.allDay,
    this.blockTime
  });

  factory ClosingDateModel.fromJson(Map<String,dynamic> json){
    return ClosingDateModel(
        id:json['id'].toString(),
        date:json['date'],
      allDay: json['all_day'],
      blockTime: json['block_time']
    );
  }

}