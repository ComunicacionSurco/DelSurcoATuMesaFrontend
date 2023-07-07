/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surco/features/products/domain/domain.dart';
import 'package:surco/features/products/presentation/providers/partys_repository_provider.dart';

final partyProvider = StateNotifierProvider.autoDispose
    .family<PartyNotifier, PartyState, String>((ref, partyId) {
  final partysRepository = ref.watch(partysRepositoryProvider);

  return PartyNotifier(partysRepository: partysRepository, partyId: partyId);
});

class PartyNotifier extends StateNotifier<PartyState> {
  final PartysRepository partysRepository;

  PartyNotifier({required this.partysRepository, required partyId})
      : super(PartyState(id: partyId)) {
    loadParty();
  }


  Party newEmptyParty() {
    return Party(
      id: 'new', 
      title: 'Title', 
      price: 100, 
      description: '', 
      slug: '', 
      stock: 10, 
      sizes: ['M'], 
      gender: 'men', 
      tags: ['old'], 
      images: [],
    );
  }

  Future<void> loadParty() async {

    try { 

      if ( state.id == 'new' ) {
        state = state.copyWith(
          isLoading: false,
          party: newEmptyParty(),
        );  
        return;
      }

      final party = await partysRepository.getPartysById(state.id);

      state = state.copyWith(
        isLoading: false,
        party: party
      );

     } catch (e) {
      // 404 product not found
      throw (Exception);
    } 

  }

}

class PartyState {
  final String id;
  final Party? party;
  final bool isLoading;
  final bool isSaving;

  PartyState(
      {required this.id,
      this.party,
      this.isLoading = true,
      this.isSaving = false});

  PartyState copyWith({
    String? id,
    Party? party,
    bool? isLoading,
    bool? isSaving,
  }) =>
      PartyState(
          id: id ?? this.id,
          party: party ?? this.party,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}
