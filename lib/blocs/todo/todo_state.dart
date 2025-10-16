import 'package:equatable/equatable.dart';
import '../../models/todo.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];

  /// 現在のTODOリストを取得するヘルパーメソッド
  List<Todo> get currentTodos => switch (this) {
    TodoLoaded(:final todos) => todos,
    TodoOperationLoading(:final todos) => todos,
    TodoError(:final todos) => todos ?? <Todo>[],
    _ => <Todo>[],
  };
}

class TodoInitial extends TodoState {
  const TodoInitial();
}

class TodoLoading extends TodoState {
  const TodoLoading();
}

class TodoLoaded extends TodoState {
  const TodoLoaded({required this.todos});
  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];
}

class TodoOperationLoading extends TodoState {
  // 'creating', 'updating', 'deleting'

  const TodoOperationLoading({required this.todos, required this.operation});
  final List<Todo> todos;
  final String operation;

  @override
  List<Object?> get props => [todos, operation];
}

class TodoError extends TodoState {
  // エラー時も現在のリストを保持

  const TodoError({required this.message, this.todos});
  final String message;
  final List<Todo>? todos;

  @override
  List<Object?> get props => [message, todos];
}
