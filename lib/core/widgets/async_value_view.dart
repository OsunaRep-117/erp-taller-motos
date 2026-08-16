import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget reutilizable para estados AsyncValue con manejo uniforme.
class AsyncValueView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stack)? errorBuilder;
  final Widget? empty;
  final bool Function(T data)? isEmpty;

  const AsyncValueView({
    super.key,
    required this.value,
    required this.builder,
    this.loading,
    this.errorBuilder,
    this.empty,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (data) {
        if (empty != null && (isEmpty?.call(data) ?? false)) {
          return empty!;
        }
        return builder(data);
      },
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          errorBuilder?.call(error, stack) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error.toString().replaceFirst('Exception: ', ''),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
