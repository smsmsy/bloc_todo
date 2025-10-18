import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_response.dart';
import '../models/todo.dart';

class TodoApiService {
  TodoApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _base = baseUrl ?? 'http://localhost:8080';
  final String _base;
  static const _path = '/api/todos';
  static const _headers = {'Content-Type': 'application/json'};

  final http.Client _client;

  Future<List<Todo>> getTodos() async {
    final uri = Uri.parse(_base + _path);
    late final http.Response response;
    try {
      response = await _client.get(uri, headers: _headers);
    } on Exception catch (e, st) {
      throw Exception('Failed to api connection: $e\n$st');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to load todos: ${response.statusCode}');
    }

    final todoListResponse = TodoListResponse.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
    return todoListResponse.data;
  }

  Future<Todo> createTodo({required String title, String? description}) async {
    final uri = Uri.parse(_base + _path);
    late final http.Response response;
    final body = <String, dynamic>{
      'title': title,
    };
    if (description != null) {
      body['description'] = description;
    }
    try {
      response = await _client.post(
        uri,
        headers: _headers,
        body: json.encode(body),
      );
    } on Exception catch (e, st) {
      throw Exception('Failed to api connection: $e\n$st');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final todoResponse = TodoResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
      return todoResponse.data;
    } else {
      throw Exception('Failed to create todo: ${response.statusCode}');
    }
  }

  Future<Todo> getTodoById(int id) async {
    final uri = Uri.parse('$_base$_path/$id');

    late final http.Response response;
    try {
      response = await _client.get(uri, headers: _headers);
    } on Exception catch (e, st) {
      throw Exception('Failed to get: $e\n$st');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load todo: ${response.statusCode}');
    }
    final todoResponse = TodoResponse.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
    return todoResponse.data;
  }

  Future<Todo> updateTodo({
    required int id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    final body = _genUpdateApiBody(title, description, completed);
    final uri = Uri.parse('$_base$_path/$id');
    late final http.Response response;
    try {
      response = await _client.put(
        uri,
        headers: _headers,
        body: json.encode(body),
      );
    } on Exception catch (e, st) {
      throw Exception('Failed to update todo: $e\n$st');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo: ${response.statusCode}');
    }
    final todoResponse = TodoResponse.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
    return todoResponse.data;
  }

  Map<String, dynamic> _genUpdateApiBody(
    String? title,
    String? description,
    bool? completed,
  ) {
    final body = <String, dynamic>{};
    if (title != null) {
      body['title'] = title;
    }
    if (description != null) {
      body['description'] = description;
    }
    if (completed != null) {
      body['completed'] = completed;
    }
    return body;
  }

  Future<void> deleteTodo(int id) async {
    final uri = Uri.parse('$_base$_path/$id');
    late final http.Response response;

    try {
      response = await _client.delete(uri, headers: _headers);
    } on Exception catch (e, st) {
      throw Exception('Failed to delete todo: $e\n$st');
    }

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo: ${response.statusCode}');
    }
  }

  Future<bool> healthCheck() async {
    final uri = Uri.parse('$_base/health');
    try {
      final response = await _client.get(uri, headers: _headers);
      return response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
