import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Checkbox(value: todo.completed, onChanged: (_) => onToggle()),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed ? Theme.of(context).disabledColor : null,
          ),
        ),
        subtitle: todo.description != null && todo.description!.isNotEmpty
            ? Text(
                todo.description!,
                style: TextStyle(
                  color: todo.completed
                      ? Theme.of(context).disabledColor
                      : null,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: onEdit,
              tooltip: '編集',
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: onDelete,
              tooltip: '削除',
            ),
          ],
        ),
        onTap: onToggle,
      ),
    );
  }
}
