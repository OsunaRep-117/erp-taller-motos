import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cliente.dart';
import '../repositories/crm_repository.dart';

class ActualizarCliente {
  final CrmRepository repository;
  const ActualizarCliente(this.repository);

  Future<Either<Failure, Cliente>> call(Cliente cliente) => repository.actualizarCliente(cliente);
}
