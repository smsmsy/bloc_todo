import 'package:bloc/bloc.dart';
import '../../models/todo.dart';
import '../../repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({TodoRepository? todoRepository})
    : _todoRepository = todoRepository ?? TodoRepository(),
      super(const TodoInitial()) {
    on<TodoLoadRequested>(_onTodoLoadRequested);
    on<TodoAdded>(_onTodoAdded);
    on<TodoUpdated>(_onTodoUpdated);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoToggled>(_onTodoToggled);
  }

  final TodoRepository _todoRepository;

  Future<void> _onTodoLoadRequested(
    TodoLoadRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoLoading());
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(message: 'Failed to load todos: $e'));
    }
  }

  Future<void> _onTodoAdded(TodoAdded event, Emitter<TodoState> emit) async {
    final currentTodos = state.currentTodos;

    emit(TodoOperationLoading(todos: currentTodos, operation: 'creating'));

    try {
      final newTodo = await _todoRepository.createTodo(
        title: event.title,
        description: event.description,
      );

      final updatedTodos = List<Todo>.from(currentTodos)..add(newTodo);
      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(
        TodoError(
          message: 'Failed to create todo: $e',
          todos: currentTodos,
        ),
      );
    }
  }

  Future<void> _onTodoUpdated(
    TodoUpdated event,
    Emitter<TodoState> emit,
  ) async {
    final currentTodos = state.currentTodos;

    emit(TodoOperationLoading(todos: currentTodos, operation: 'updating'));

    try {
      final updatedTodo = await _todoRepository.updateTodo(
        id: event.id,
        title: event.title,
        description: event.description,
        completed: event.completed,
      );

      final updatedTodos = currentTodos.map((todo) {
        return todo.id == event.id ? updatedTodo : todo;
      }).toList();

      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(
        TodoError(
          message: 'Failed to update todo: $e',
          todos: currentTodos,
        ),
      );
    }
  }

  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    final currentTodos = state.currentTodos;

    emit(TodoOperationLoading(todos: currentTodos, operation: 'deleting'));

    try {
      await _todoRepository.deleteTodo(event.id);

      final updatedTodos = currentTodos
          .where((todo) => todo.id != event.id)
          .toList();
      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(
        TodoError(
          message: 'Failed to delete todo: $e',
          todos: currentTodos,
        ),
      );
    }
  }

  Future<void> _onTodoToggled(
    TodoToggled event,
    Emitter<TodoState> emit,
  ) async {
    final currentTodos = state.currentTodos;

    final todoToToggle = currentTodos.firstWhere(
      (todo) => todo.id == event.id,
      orElse: () => throw Exception('Todo not found'),
    );

    emit(TodoOperationLoading(todos: currentTodos, operation: 'updating'));

    try {
      final updatedTodo = await _todoRepository.updateTodo(
        id: event.id,
        completed: !todoToToggle.completed,
      );

      final updatedTodos = currentTodos.map((todo) {
        return todo.id == event.id ? updatedTodo : todo;
      }).toList();

      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(
        TodoError(
          message: 'Failed to toggle todo: $e',
          todos: currentTodos,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _todoRepository.dispose();
    return super.close();
  }
}
