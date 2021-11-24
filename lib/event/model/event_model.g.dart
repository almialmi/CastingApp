// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    totalItems: json['totalItems'] as int,
    totalPages: json['totalPages'] as int,
    pageNumber: json['pageNumber'] as int,
    pageSize: json['pageSize'] as int,
    events: (json['events'] as List)
        ?.map((e) =>
            e == null ? null : EventElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'message': instance.message,
      'events': instance.events,
    };
