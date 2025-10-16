import '../models/todo.dart';
import '../services/todo_api_service.dart';

class TodoRepository {
  TodoRepository({TodoApiService? apiService})
    : _apiService = apiService ?? TodoApiService();
  final TodoApiService _apiService;

  Future<List<Todo>> getTodos() {
    return _apiService.getTodos();
  }

  Future<Todo> createTodo({required String title, String? description}) {
    return _apiService.createTodo(title: title, description: description);
  }

  Future<Todo> getTodoById(int id) {
    return _apiService.getTodoById(id);
  }

  Future<Todo> updateTodo({
    required int id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return _apiService.updateTodo(
      id: id,
      title: title,
      description: description,
      completed: completed,
    );
  }

  Future<void> deleteTodo(int id) {
    return _apiService.deleteTodo(id);
  }

  Future<bool> healthCheck() {
    return _apiService.healthCheck();
  }

  void dispose() {
    _apiService.dispose();
  }
}
