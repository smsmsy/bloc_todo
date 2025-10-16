import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoLoadRequested extends TodoEvent {
  const TodoLoadRequested();
}

class TodoAdded extends TodoEvent {
  const TodoAdded({required this.title, this.description});
  final String title;
  final String? description;

  @override
  List<Object?> get props => [title, description];
}

class TodoUpdated extends TodoEvent {
  const TodoUpdated({
    required this.id,
    this.title,
    this.description,
    this.completed,
  });
  final int id;
  final String? title;
  final String? description;
  final bool? completed;

  @override
  List<Object?> get props => [id, title, description, completed];
}

class TodoDeleted extends TodoEvent {
  const TodoDeleted({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}

class TodoToggled extends TodoEvent {
  const TodoToggled({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}
