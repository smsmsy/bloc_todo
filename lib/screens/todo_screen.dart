import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';
import '../blocs/todo/todo_state.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO アプリ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TodoBloc>().add(const TodoLoadRequested());
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'テーマ切替',
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
          ),
        ],
      ),
      body: const TodoScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        tooltip: 'TODO追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<TodoBloc>(),
          child: const AddTodoDialog(),
        );
      },
    );
  }
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) => switch (state) {
        TodoInitial() => (BuildContext context, TodoState state) {
          // 初期読み込み
          context.read<TodoBloc>().add(const TodoLoadRequested());
          return const _ProgressScreen();
        }(context, state),
        TodoLoading() => const _ProgressScreen(),
        TodoError() => const _ErrorScreen(),
        TodoLoaded() => const _MainScreen(),
        TodoOperationLoading() => const _MainScreen(),
      },
    );
  }
}

class _MainScreen extends StatelessWidget {
  const _MainScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        final todos = state.currentTodos;

        return Column(
          children: [
            if (switch (state) {
              TodoOperationLoading() => true,
              _ => false,
            })
              LinearProgressIndicator(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checklist,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'TODOがありません',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '+ ボタンを押して新しいTODOを追加してください',
                            style: TextStyle(
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : TodoList(todos: todos),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressScreen extends StatelessWidget {
  const _ProgressScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        state as TodoError;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'エラーが発生しました',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<TodoBloc>().add(const TodoLoadRequested());
                },
                child: const Text('再試行'),
              ),
            ],
          ),
        );
      },
    );
  }
}
