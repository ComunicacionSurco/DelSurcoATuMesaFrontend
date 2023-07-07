/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surco/features/products/presentation/providers/partys_repository_provider.dart';
import '../../domain/domain.dart';


final partysProvider = StateNotifierProvider<PartysNotifier,PartysState>((ref) {
  
  final partysRepository = ref.watch(partysRepositoryProvider);
  
  return PartysNotifier(partysRepository: partysRepository );
});


class PartysNotifier extends StateNotifier<PartysState> {
  final PartysRepository partysRepository;

  PartysNotifier({required this.partysRepository}) : super(PartysState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateParty(Map <String, dynamic> partyLike) async{

    try {
      final party = await partysRepository.createUpdateParty(partyLike);
      final isProductInList = state.partys.any((element) => element.id == party.id);

      if(!isProductInList){
        state = state.copyWith(
          partys: [...state.partys,party]
        );
        return true;
      }

      state = state.copyWith(
        partys: state.partys.map((element) => (element.id == party.id) ? party : element).toList());

      return true;
      
    } catch (e) {
      return false;
    }


  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final partys = await partysRepository.getPartysByPage(
        limit: state.limit, offset: state.offset);

    if (partys.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 100,
        partys: [...state.partys, ...partys]);
  }
}

class PartysState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Party> partys;

  PartysState(
      {this.isLastPage = false,
      this.limit = 100,
      this.offset = 0,
      this.isLoading = false,
      this.partys = const []});

  PartysState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Party>? partys,
  }) =>
      PartysState(
          isLastPage: isLastPage ?? this.isLastPage,
          limit: limit ?? this.limit,
          offset: offset ?? this.offset,
          isLoading: isLoading ?? this.isLoading,
          partys: partys ?? this.partys);
}
