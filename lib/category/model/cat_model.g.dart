// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    // photo: json['photo'] == null
    //     ? null
    //     : Photo.fromJson(json['photo'] as Map<String, dynamic>),
    photo: json['photo'] as String,
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'photo': instance.photo,
      'id': instance.id,
      'name': instance.name,
    };
