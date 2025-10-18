import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';
import '../blocs/todo/todo_state.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_list.dart';
import '../widgets/top_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: TopBar(),
      ),
      body: const TodoScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTodoDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('TODOを追加'),
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
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.04),
            theme.colorScheme.secondary.withValues(alpha: 0.02),
            Colors.transparent,
          ],
        ),
      ),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) => switch (state) {
          TodoInitial() => (BuildContext context, TodoState state) {
            context.read<TodoBloc>().add(const TodoLoadRequested());
            return const _ProgressScreen();
          }(context, state),
          TodoLoading() => const _ProgressScreen(),
          TodoError() => const _ErrorScreen(),
          TodoLoaded() => const _MainScreen(),
          TodoOperationLoading() => const _MainScreen(),
        },
      ),
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
        final isBusy = state is TodoOperationLoading;
        final theme = Theme.of(context);

        return Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchOutCurve: Curves.easeInCubic,
              switchInCurve: Curves.easeOutCubic,
              child: isBusy
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 24),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: todos.isEmpty
                    ? const _EmptyState(key: ValueKey('empty_state'))
                    : TodoList(
                        key: const ValueKey('todo_list'),
                        todos: todos,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_alt_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'タスクはまだありません',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '右下の「TODOを追加」ボタンから最初のタスクを作成しましょう。',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressScreen extends StatelessWidget {
  const _ProgressScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: 1,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.06 * 256).round()),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 64,
                width: 64,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '読み込み中です…',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        state as TodoError;
        final theme = Theme.of(context);
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              elevation: 8,
              shadowColor: Colors.black.withAlpha((0.08 * 256).round()),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 56,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'エラーが発生しました',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text('閉じる'),
                        ),
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context.read<TodoBloc>().add(
                            const TodoLoadRequested(),
                          ),
                          label: const Text('再試行'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
