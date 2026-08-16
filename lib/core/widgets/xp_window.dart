import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Marco tipo ventana Windows XP reutilizable en login, paneles y diálogos.
class XpWindow extends StatelessWidget {
  final String title;
  final Widget child;
  final double? maxWidth;
  final EdgeInsets padding;

  const XpWindow({
    super.key,
    required this.title,
    required this.child,
    this.maxWidth,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 520),
      child: Material(
        color: XpColors.panelBg,
        elevation: 4,
        shadowColor: Colors.black54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [XpColors.titleStart, XpColors.titleEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.two_wheeler, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Tahoma',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: XpColors.borderDark),
                  right: BorderSide(color: XpColors.borderDark),
                  bottom: BorderSide(color: XpColors.borderDark),
                ),
              ),
              child: Padding(padding: padding, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra superior azul para AppScaffold.
class XpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  const XpAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize {
    final bottomH = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomH);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [XpColors.titleStart, XpColors.titleEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: Text(title),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// Panel con borde hundido estilo XP.
class XpPanel extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets padding;

  const XpPanel({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: XpColors.panelBg,
        border: Border.all(color: XpColors.borderDark),
        boxShadow: const [
          BoxShadow(color: XpColors.borderLight, offset: Offset(-1, -1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: XpColors.windowBg,
              child: Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

/// Tarjeta KPI compacta estilo XP.
class XpKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const XpKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.accent = XpColors.selection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      decoration: BoxDecoration(
        color: XpColors.panelBg,
        border: Border.all(color: XpColors.borderDark),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila de lista con marco XP.
class XpEntityCard extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const XpEntityCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Material(
        color: XpColors.panelBg,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: XpColors.borderDark.withValues(alpha: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 10)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        child: title,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip de estado con colores XP.
class XpStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const XpStatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: color.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Título de sección dentro de pantallas.
class XpSectionTitle extends StatelessWidget {
  final String text;
  const XpSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: XpColors.titleStart,
        ),
      ),
    );
  }
}

/// Mensaje vacío centrado.
class XpEmptyState extends StatelessWidget {
  final String message;
  const XpEmptyState(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: XpPanel(
        title: 'Información',
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
