// To parse this JSON data, do
//
//     final listPelatihan = listPelatihanFromJson(jsonString);

import 'dart:convert';

ListPelatihan listPelatihanFromJson(String str) =>
    ListPelatihan.fromJson(json.decode(str));

String listPelatihanToJson(ListPelatihan data) => json.encode(data.toJson());

class ListPelatihan {
  String message;
  List<DataTraining> data;

  ListPelatihan({required this.message, required this.data});

  factory ListPelatihan.fromJson(Map<String, dynamic> json) => ListPelatihan(
    message: json["message"],
    data: List<DataTraining>.from(
      json["data"].map((x) => DataTraining.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataTraining {
  int id;
  String title;

  DataTraining({required this.id, required this.title});

  factory DataTraining.fromJson(Map<String, dynamic> json) =>
      DataTraining(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
