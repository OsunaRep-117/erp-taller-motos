import 'package:equatable/equatable.dart';

/// Los repositorios devuelven Either<Failure, T> en vez de lanzar
/// excepciones, para que la capa de presentación maneje errores
/// de forma explícita y predecible.
abstract class Failure extends Equatable {
  final String mensaje;
  const Failure(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}

class ServerFailure extends Failure {
  const ServerFailure(super.mensaje);
}

class ReglaDeNegocioFailure extends Failure {
  const ReglaDeNegocioFailure(super.mensaje);
}

class SinConexionFailure extends Failure {
  const SinConexionFailure([super.mensaje = 'Sin conexión a internet']);
}
