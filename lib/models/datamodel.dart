class ShowDataModel {
  int? id;
  String? task;
  String? taskdesc;

  ShowDataModel({this.id, this.task, this.taskdesc});

  ShowDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    task = json['task'];
    taskdesc = json['taskdesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task'] = this.task;
    data['taskdesc'] = this.taskdesc;
    return data;
  }
}
