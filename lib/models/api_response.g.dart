// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(data: fromJsonT(json['data']));

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'data': toJsonT(instance.data)};

TodoListResponse _$TodoListResponseFromJson(Map<String, dynamic> json) =>
    TodoListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TodoListResponseToJson(TodoListResponse instance) =>
    <String, dynamic>{'data': instance.data};

TodoResponse _$TodoResponseFromJson(Map<String, dynamic> json) =>
    TodoResponse(data: Todo.fromJson(json['data'] as Map<String, dynamic>));

Map<String, dynamic> _$TodoResponseToJson(TodoResponse instance) =>
    <String, dynamic>{'data': instance.data};
