import 'package:bodysyncapp/models/gymClass.dart';
import 'package:bodysyncapp/models/gymUser.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class ClassFeedbackModel {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'gymUser')
  GymUser? gymUser;

  @JsonKey(name: 'gymClass')
  GymClass? gymClass;

  @JsonKey(name: 'rating')
  int? rating;

  @JsonKey(name: 'comments')
  String? comments;

  ClassFeedbackModel({
    this.id,
    required this.gymUser,
    required this.gymClass,
    this.rating,
    required this.comments,
  });

  factory ClassFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ClassFeedbackModel(
      id: json['id'],
      gymUser: GymUser.fromJson(json['gymUser']),
      gymClass: GymClass.fromJson(json['gymClass']),
      rating: json['rating'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUser': gymUser?.toJson(),
      'gymClass': gymClass?.toJson(),
      'rating': rating,
      'comments': comments,
    };
  }
}
