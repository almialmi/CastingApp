// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Userr _$UserrFromJson(Map<String, dynamic> json) {
  return Userr(
      id: json['id'] as String,
      userName: json['userName'],
      email: json['email'] as String,
      password: json['password'] as String,
      profilePic: json['profilePic'] as String

      //   profilePic: json['profilePic'] == null
      //       ? null
      //       : ProfilePic.fromJson(json['profilePic'] as Map<String, dynamic>),
      );
}

Map<String, dynamic> _$UserrToJson(Userr instance) => <String, dynamic>{
      'password': instance.password,
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'profilePic': instance.profilePic,
    };
