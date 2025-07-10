// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

class RegisterResponse {
  String? message;
  Data? data;
  Map<String, List<String>>? errors;

  RegisterResponse({this.message, this.data, this.errors});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json["message"],
      data:
          json.containsKey("data") && json["data"] != null
              ? Data.fromJson(json["data"])
              : null,
      errors:
          json.containsKey("errors") && json["errors"] != null
              ? Map<String, List<String>>.from(
                json["errors"].map(
                  (key, value) => MapEntry(key, List<String>.from(value)),
                ),
              )
              : null,
    );
  }
}

class Data {
  String token;
  User user;
  String? profilePhotoUrl;

  Data({
    required this.token,
    required this.user,
    required this.profilePhotoUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: User.fromJson(json["user"]),
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
    "profile_photo_url": profilePhotoUrl,
  };
}

class User {
  String name;
  String email;
  int batchId;
  int trainingId;
  String jenisKelamin;
  String? profilePhoto;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  Batch batch;
  Training training;

  User({
    required this.name,
    required this.email,
    required this.batchId,
    required this.trainingId,
    required this.jenisKelamin,
    required this.profilePhoto,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.batch,
    required this.training,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    batchId: json["batch_id"],
    trainingId: json["training_id"],
    jenisKelamin: json["jenis_kelamin"],
    profilePhoto: json["profile_photo"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    batch: Batch.fromJson(json["batch"]),
    training: Training.fromJson(json["training"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "batch_id": batchId,
    "training_id": trainingId,
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "batch": batch.toJson(),
    "training": training.toJson(),
  };
}

class Batch {
  int id;
  String batchKe;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;

  Batch({
    required this.id,
    required this.batchKe,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
    id: json["id"],
    batchKe: json["batch_ke"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_ke": batchKe,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Training {
  int id;
  String title;
  dynamic description;
  dynamic participantCount;
  dynamic standard;
  dynamic duration;
  DateTime createdAt;
  DateTime updatedAt;

  Training({
    required this.id,
    required this.title,
    required this.description,
    required this.participantCount,
    required this.standard,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    participantCount: json["participant_count"],
    standard: json["standard"],
    duration: json["duration"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "participant_count": participantCount,
    "standard": standard,
    "duration": duration,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final loginRespons = loginResponsFromJson(jsonString);

LoginRespons loginResponsFromJson(String str) =>
    LoginRespons.fromJson(json.decode(str));

String loginResponsToJson(LoginRespons data) => json.encode(data.toJson());

class LoginRespons {
  String message;
  DataLogin data;

  LoginRespons({required this.message, required this.data});

  factory LoginRespons.fromJson(Map<String, dynamic> json) => LoginRespons(
    message: json["message"],
    data: DataLogin.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class DataLogin {
  String token;
  UserLogin user;

  DataLogin({required this.token, required this.user});

  factory DataLogin.fromJson(Map<String, dynamic> json) =>
      DataLogin(token: json["token"], user: UserLogin.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
}

class UserLogin {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String batchId; // <- dari "1" (string)
  String trainingId; // <- dari "16" (string)
  String jenisKelamin;
  dynamic profilePhoto;
  dynamic onesignalPlayerId;
  BatchLogin batch;
  TrainingLogin training;

  UserLogin({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.batchId,
    required this.trainingId,
    required this.jenisKelamin,
    required this.profilePhoto,
    required this.onesignalPlayerId,
    required this.batch,
    required this.training,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    batchId: json["batch_id"].toString(), // 🔧 force to String
    trainingId: json["training_id"].toString(), // 🔧 force to String
    jenisKelamin: json["jenis_kelamin"],
    profilePhoto: json["profile_photo"],
    onesignalPlayerId: json["onesignal_player_id"],
    batch: BatchLogin.fromJson(json["batch"]),
    training: TrainingLogin.fromJson(json["training"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "batch_id": batchId,
    "training_id": trainingId,
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
    "onesignal_player_id": onesignalPlayerId,
    "batch": batch.toJson(),
    "training": training.toJson(),
  };
}

class BatchLogin {
  int id;
  String batchKe;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;

  BatchLogin({
    required this.id,
    required this.batchKe,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BatchLogin.fromJson(Map<String, dynamic> json) => BatchLogin(
    id: json["id"],
    batchKe: json["batch_ke"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_ke": batchKe,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class TrainingLogin {
  int id;
  String title;
  dynamic description;
  dynamic participantCount;
  dynamic standard;
  dynamic duration;
  DateTime createdAt;
  DateTime updatedAt;

  TrainingLogin({
    required this.id,
    required this.title,
    required this.description,
    required this.participantCount,
    required this.standard,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainingLogin.fromJson(Map<String, dynamic> json) => TrainingLogin(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    participantCount: json["participant_count"],
    standard: json["standard"],
    duration: json["duration"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "participant_count": participantCount,
    "standard": standard,
    "duration": duration,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
// To parse this JSON data, do
//
//     final profileRespons = profileResponsFromJson(jsonString);

ProfileRespons profileResponsFromJson(String str) =>
    ProfileRespons.fromJson(json.decode(str));

String profileResponsToJson(ProfileRespons data) => json.encode(data.toJson());

class ProfileRespons {
  String message;
  DataProfile data;

  ProfileRespons({required this.message, required this.data});

  factory ProfileRespons.fromJson(Map<String, dynamic> json) => ProfileRespons(
    message: json["message"],
    data: DataProfile.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class DataProfile {
  int id;
  String name;
  String email;
  String batchKe;
  String trainingTitle;
  BatchProfile batch;
  TrainingProfile training;
  dynamic jenisKelamin;
  String profilePhoto;

  DataProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.batchKe,
    required this.trainingTitle,
    required this.batch,
    required this.training,
    required this.jenisKelamin,
    required this.profilePhoto,
  });

  factory DataProfile.fromJson(Map<String, dynamic> json) => DataProfile(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    batchKe: json["batch_ke"],
    trainingTitle: json["training_title"],
    batch: BatchProfile.fromJson(json["batch"]),
    training: TrainingProfile.fromJson(json["training"]),
    jenisKelamin: json["jenis_kelamin"],
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "batch_ke": batchKe,
    "training_title": trainingTitle,
    "batch": batch.toJson(),
    "training": training.toJson(),
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
  };
}

class BatchProfile {
  int id;
  String batchKe;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;

  BatchProfile({
    required this.id,
    required this.batchKe,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BatchProfile.fromJson(Map<String, dynamic> json) => BatchProfile(
    id: json["id"],
    batchKe: json["batch_ke"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_ke": batchKe,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class TrainingProfile {
  int id;
  String title;
  dynamic description;
  dynamic participantCount;
  dynamic standard;
  dynamic duration;
  DateTime createdAt;
  DateTime updatedAt;

  TrainingProfile({
    required this.id,
    required this.title,
    required this.description,
    required this.participantCount,
    required this.standard,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainingProfile.fromJson(Map<String, dynamic> json) =>
      TrainingProfile(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        participantCount: json["participant_count"],
        standard: json["standard"],
        duration: json["duration"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "participant_count": participantCount,
    "standard": standard,
    "duration": duration,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
