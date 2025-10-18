import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          titlePadding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
          contentPadding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '新しいTODO',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'タスクの概要と詳細を入力してください',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル *',
                    hintText: 'TODOのタイトルを入力',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'タイトルを入力してください';
                    }
                    return null;
                  },
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明（任意）',
                    hintText: 'TODOの詳細説明',
                  ),
                  maxLines: 4,
                  minLines: 3,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitForm(),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _submitForm,
              label: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      context.read<TodoBloc>().add(
        TodoAdded(
          title: title,
          description: description.isEmpty ? null : description,
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
