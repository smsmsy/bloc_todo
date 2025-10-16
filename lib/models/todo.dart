import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  final int id;
  final String title;
  final String? description;
  final bool completed;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    completed,
    createdAt,
    updatedAt,
  ];
}
