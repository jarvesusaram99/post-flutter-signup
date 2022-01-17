// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Post postFromJson(dynamic str) => Post.fromJson(json.decode(str));

String postToJson(dynamic data) => json.encode(data.toJson());

class Post {
    Post({
       required this.status,
       required this.message,
       required this.errorCode,
       required this.errorMsg,
       required this.data,
       required this.metaParams,
    });

    bool status;
    Message message;
    dynamic errorCode;
    dynamic errorMsg;
    List<Datum> data;
    dynamic metaParams;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        status: json["status"],
        message: Message.fromJson(json["message"]),
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        metaParams: json["meta_params"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message.toJson(),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta_params": metaParams,
    };
}

class Datum {
    Datum({
       required this.id,
       required this.name,
       required this.icon,
       required this.banner,
       required this.bgcolor,
    });

    int id;
    Message name;
    String icon;
    dynamic banner;
    String bgcolor;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: Message.fromJson(json["name"]),
        icon: json["icon"],
        banner: json["banner"],
        bgcolor: json["bgcolor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name.toJson(),
        "icon": icon,
        "banner": banner,
        "bgcolor": bgcolor,
    };
}

class Message {
    Message({
       required this.en,
       required this.hi,
    });

    String en;
    String hi;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        en: json["EN"],
        hi: json["HI"],
    );

    Map<String, dynamic> toJson() => {
        "EN": en,
        "HI": hi,
    };
}
