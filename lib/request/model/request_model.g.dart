// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request(
    totalItems: json['totalItems'] as int,
    totalPages: json['totalPages'],
    pageNumber: json['pageNumber'],
    pageSize: json['pageSize'] as int,
    request: (json['request'] as List)
        ?.map((e) => e == null
            ? null
            : RequestElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'request': instance.request,
    };
