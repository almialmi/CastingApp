// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'female_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    totalItems: json['totalItems'] as int,
    totalPages: json['totalPages'],
    pageNumber: json['pageNumber'],
    pageSize: json['pageSize'] as int,
    post: (json['post'] as List)
        ?.map((e) =>
            e == null ? null : PostElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'post': instance.post,
    };
