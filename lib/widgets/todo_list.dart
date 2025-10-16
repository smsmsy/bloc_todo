import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';
import '../models/todo.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key, required this.todos});
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onToggle: () {
            context.read<TodoBloc>().add(TodoToggled(id: todo.id));
          },
          onDelete: () {
            _showDeleteConfirmation(context, todo);
          },
          onEdit: () {
            _showEditDialog(context, todo);
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Todo todo) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('TODO削除'),
          content: Text('「${todo.title}」を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TodoBloc>().add(TodoDeleted(id: todo.id));
              },
              child: Text(
                '削除',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(
      text: todo.description ?? '',
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('TODO編集'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'タイトル',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '説明（任意）',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  Navigator.of(dialogContext).pop();
                  context.read<TodoBloc>().add(
                    TodoUpdated(
                      id: todo.id,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                    ),
                  );
                }
              },
              child: const Text('更新'),
            ),
          ],
        );
      },
    );
  }
}
