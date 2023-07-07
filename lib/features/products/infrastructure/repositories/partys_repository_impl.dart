/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:surco/features/products/domain/domain.dart';

class PartysRepositoryImpl extends PartysRepository{
  final PartysDatSource datasource;

  PartysRepositoryImpl(this.datasource);

  @override
  Future<Party> createUpdateParty(Map<String, dynamic> partyLike) {
    return datasource.createUpdateParty(partyLike);
  }

  @override
  Future<Party> getPartysById(String id) {
    return datasource.getPartysById(id);
  }

  @override
  Future<List<Party>> getPartysByPage({int limit = 100, int offset = 0}) {
    return datasource.getPartysByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Party>> searchPartyByTerm(String term) {
    return datasource.searchPartyByTerm(term);
  }

}