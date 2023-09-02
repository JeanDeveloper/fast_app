import 'dart:convert';

mToken mTokenFromJson(String str) => mToken.fromJson(json.decode(str));

String mTokenToJson(mToken data) => json.encode(data.toJson());

class mToken {
  mToken({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory mToken.fromJson(Map<String, dynamic> json) => mToken(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.token,
    this.tVersionAndroid,
    this.tVersionIos,
  });

  String? token;
  String? tVersionAndroid;
  String? tVersionIos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["_token"],
        tVersionAndroid: json["tVersionAndroid"],
        tVersionIos: json["tVersionIOS"],
      );

  Map<String, dynamic> toJson() => {
        "_token": token,
        "tVersionAndroid": tVersionAndroid,
        "tVersionIOS": tVersionIos,
      };
}
