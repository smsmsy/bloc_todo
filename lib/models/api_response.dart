import 'package:json_annotation/json_annotation.dart';
import 'todo.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
  final T data;

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable()
class TodoListResponse {
  const TodoListResponse({required this.data});

  factory TodoListResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoListResponseFromJson(json);
  final List<Todo> data;
  Map<String, dynamic> toJson() => _$TodoListResponseToJson(this);
}

@JsonSerializable()
class TodoResponse {
  const TodoResponse({required this.data});

  factory TodoResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoResponseFromJson(json);
  final Todo data;
  Map<String, dynamic> toJson() => _$TodoResponseToJson(this);
}
