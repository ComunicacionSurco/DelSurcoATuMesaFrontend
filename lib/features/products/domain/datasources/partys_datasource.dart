/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:surco/features/products/domain/entities/party.dart';

abstract class PartysDatSource{
  Future<List<Party>> getPartysByPage({int limit = 100, int offset = 0});
  
  
  Future<Party> getPartysById(String id);

  Future<List<Party>> searchPartyByTerm(String term);

  Future<Party> createUpdateParty(Map<String,dynamic>partyLike);
}