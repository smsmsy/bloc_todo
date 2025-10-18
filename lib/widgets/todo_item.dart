import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final theme = Theme.of(context);
    final isCompleted = todo.completed;
    final updatedLabel = DateFormat(
      'M/d(E) HH:mm',
      'ja',
    ).format(todo.updatedAt);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      opacity: isCompleted ? 0.78 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isCompleted ? 0.03 : 0.08,
              ),
              blurRadius: isCompleted ? 10 : 18,
              offset: Offset(0, isCompleted ? 4 : 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompletionIndicator(
                    completed: isCompleted,
                    color: theme.colorScheme.primary,
                    onToggle: onToggle,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                todo.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: isCompleted ? 0.7 : 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _TodoActions(onEdit: onEdit, onDelete: onDelete),
                          ],
                        ),
                        if (todo.description?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 12),
                          Text(
                            todo.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '更新: $updatedLabel',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionIndicator extends StatelessWidget {
  const _CompletionIndicator({
    required this.completed,
    required this.color,
    required this.onToggle,
  });

  final bool completed;
  final Color color;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: completed ? color : Colors.transparent,
          border: Border.all(
            color: completed ? Colors.transparent : color,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.check,
          size: 18,
          color: completed ? Colors.white : color,
        ),
      ),
    );
  }
}

class _TodoActions extends StatelessWidget {
  const _TodoActions({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionIconButton(
          icon: Icons.edit_outlined,
          tooltip: '編集',
          color: theme.colorScheme.primary,
          onPressed: onEdit,
        ),
        const SizedBox(width: 8),
        _ActionIconButton(
          icon: Icons.delete_outline,
          tooltip: '削除',
          color: theme.colorScheme.error,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
