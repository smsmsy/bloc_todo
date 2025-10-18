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
    return ListView.separated(
      itemCount: todos.length,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      separatorBuilder: (context, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          key: ValueKey(todo.id),
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
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'TODO削除',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            '「${todo.title}」を削除しますか？',
            style: theme.textTheme.bodyMedium,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TodoBloc>().add(TodoDeleted(id: todo.id));
              },
              child: const Text('削除'),
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
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'TODO編集',
            style: theme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'タイトル',
                  hintText: 'TODOのタイトルを入力',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '説明（任意）',
                  hintText: 'TODOの詳細説明',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                final trimmedTitle = titleController.text.trim();
                final trimmedDescription = descriptionController.text.trim();
                if (trimmedTitle.isNotEmpty) {
                  Navigator.of(dialogContext).pop();
                  context.read<TodoBloc>().add(
                    TodoUpdated(
                      id: todo.id,
                      title: trimmedTitle,
                      description: trimmedDescription.isEmpty
                          ? null
                          : trimmedDescription,
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
