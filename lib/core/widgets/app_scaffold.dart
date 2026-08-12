import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_drawer.dart';
import 'xp_window.dart';

/// Scaffold estándar del ERP con estilo ventana XP.
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showDrawer;
  final bool framedBody;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.actions,
    this.bottom,
    this.showDrawer = true,
    this.framedBody = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.desktop,
      appBar: XpAppBar(
        title: title,
        actions: actions,
        bottom: bottom,
        automaticallyImplyLeading: showDrawer,
      ),
      drawer: showDrawer ? const AppDrawer() : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: framedBody ? _FramedBody(child: body) : body,
    );
  }
}

class _FramedBody extends StatelessWidget {
  final Widget child;
  const _FramedBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: XpColors.windowBg,
        border: Border.all(color: XpColors.borderDark),
      ),
      child: child,
    );
  }
}
