import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新しいTODO'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル *',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '説明（任意）',
                border: OutlineInputBorder(),
                hintText: 'TODOの詳細説明',
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitForm(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(onPressed: _submitForm, child: const Text('追加')),
      ],
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
