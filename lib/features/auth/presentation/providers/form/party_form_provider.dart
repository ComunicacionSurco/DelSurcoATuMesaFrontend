import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:surco/features/products/domain/domain.dart';
import 'package:surco/features/products/presentation/providers/partys_provider.dart';
import '../../../../../config/constants/environment.dart';
import '../../../../shared/shared.dart';

final partyFromProvider = StateNotifierProvider.autoDispose
    .family<PartyFormNotifier, PartyFormState, Party>((ref, party) {


  //final createUpdateCallback = ref.watch(partysRepositoryProvider).createUpdateParty;
  final createUpdateCallback = ref.watch(partysProvider.notifier).createOrUpdateParty;

  return PartyFormNotifier(
    party: party,
    onSubmitCallback: createUpdateCallback,
    );
});

class PartyFormNotifier extends StateNotifier<PartyFormState> {
  final Future<bool> Function(Map<String, dynamic> partyLike)? onSubmitCallback;

  PartyFormNotifier({
    this.onSubmitCallback,
    required Party party,
  }) : super(PartyFormState(
      id: party.id,
      title: Title.dirty(party.title),
      slug: Slug.dirty(party.slug),
      price: Price.dirty(party.price),
      inStock: Stock.dirty( party.stock ),
      sizes: party.sizes,
      gender: party.gender,
      description: party.description,
      tags: party.tags.join(', '),
      images: party.images,
            ));

  Future<bool> onFormSubmit() async {
    _touchedEveryThing();

    if (!state.isFormValid) return false;

    //if (onSubmitCallback == null) return false;

    final partyLike = {
      'id' : (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (image) => image.replaceAll('${ Environment.apiUrl }/files/product/', '')
      ).toList()
    };

      try {
        return await onSubmitCallback!(partyLike);
      } catch (e) {
        return false;
      }
      
  }





  _touchedEveryThing() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      //Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  void onTitleChange(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          //Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onSlugChange(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          //Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onPriceChange(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          //Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void updatePartyImage(String path){
    state = state.copyWith(
      images: [...state.images,path]
    );
  }

  void onStockChange(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          //Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ]));
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class PartyFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
    List<String> images;

  PartyFormState({
    this.isFormValid = false, 
    this.id, 
    this.title = const Title.dirty(''), 
    this.slug = const Slug.dirty(''), 
    this.price = const Price.dirty(0), 
    this.sizes = const [], 
    this.gender = 'men', 
    this.inStock = const Stock.dirty(0), 
    this.description = '', 
    this.tags = '', 
    this.images = const[]
      
      });

  PartyFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      PartyFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
      );
}
