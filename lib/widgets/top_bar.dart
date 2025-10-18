import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_event.dart';
import '../blocs/todo/todo_state.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _formatDate(DateTime.now());
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日のタスク',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _ProgressBadges(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _TopBarIconButton(
                  icon: Icons.refresh,
                  tooltip: '最新の状態を取得',
                  onPressed: () =>
                      context.read<TodoBloc>().add(const TodoLoadRequested()),
                ),
                const SizedBox(height: 12),
                const _ThemeToggleButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  try {
    return DateFormat('y年M月d日(E)', 'ja').format(date);
  } catch (_) {
    return DateFormat('y/MM/dd').format(date);
  }
}

class _ProgressBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      buildWhen: (previous, current) =>
          previous.currentTodos != current.currentTodos,
      builder: (context, state) {
        final todos = state.currentTodos;
        final completedCount = todos.where((t) => t.completed).length;
        final total = todos.length;
        final progress = total == 0 ? 0.0 : completedCount / total;
        final theme = Theme.of(context);

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Badge(
                label: '完了',
                value: '$completedCount',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              _Badge(
                label: '未完了',
                value: '${total - completedCount}',
                color: theme.colorScheme.secondary,
              ),
              if (total > 0) ...[
                const SizedBox(width: 16),
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 6,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.08),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          );
                        },
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final mode = state.themeMode;
        final isDark = mode == ThemeMode.dark;

        return _TopBarIconButton(
          icon: isDark ? Icons.nights_stay : Icons.wb_sunny,
          tooltip: 'テーマ切替',
          onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
        );
      },
    );
  }
}
