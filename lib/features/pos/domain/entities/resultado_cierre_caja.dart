class ResultadoCierreCaja {
  final String id;
  final double efectivoContado;
  final double efectivoEsperado;
  final double diferencia;
  final DateTime fecha;

  const ResultadoCierreCaja({
    required this.id,
    required this.efectivoContado,
    required this.efectivoEsperado,
    required this.diferencia,
    required this.fecha,
  });
}
