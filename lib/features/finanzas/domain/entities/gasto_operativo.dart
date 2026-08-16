class GastoOperativo {
  final String id;
  final String concepto;
  final String? categoria;
  final double monto;
  final DateTime fechaGasto;

  const GastoOperativo({
    required this.id,
    required this.concepto,
    required this.monto,
    required this.fechaGasto,
    this.categoria,
  });
}
