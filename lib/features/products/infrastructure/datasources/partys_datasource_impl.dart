/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:dio/dio.dart';
import 'package:surco/config/config.dart';
import 'package:surco/features/products/domain/domain.dart';
import 'package:surco/features/products/infrastructure/errors/party_errors.dart';
import 'package:surco/features/products/infrastructure/mappers/party_mapper.dart';

class PartysDatSourceImpl extends PartysDatSource {
  late final Dio dio;

  final String accessToken;

  PartysDatSourceImpl({
    required this.accessToken,
  }) : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));


  Future<String> _uploadFile(String path) async{
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName),
        
      });

      final respose = await dio.post('/files/product', data: data );

      return respose.data['image'];

    } catch (e) {
      throw Exception();
    }
  }



  Future <List<String>> _uploadPhotos(List<String>photos) async{
    final photosToUpload = photos.where((element) => element.contains('/')).toList();

    final photosToIgnore = photos.where((element) => !element.contains('/')).toList();


    final List<Future<String>> uploadJob = photosToUpload.map(_uploadFile).toList();
    final newImages = await Future.wait(uploadJob);

    return [...photosToIgnore,...newImages];
  }


  

  @override
  Future<Party> createUpdateParty(Map<String, dynamic> partyLike) async {
    try {
      final String? partyId = partyLike['id'];
      final String method = (partyId == null) ? 'POST' : 'PATCH';
      final String url = (partyId == null) ? '/products' : '/products/$partyId';

      partyLike.remove('id');
      partyLike['images'] = await _uploadPhotos(partyLike['images']);


      final response = await dio.request(
        url,
        data: partyLike,
        options: Options(method:method));

      final party = PartyMapper.jsonToEntity(response.data);

      return party;
    } catch (e) {
      throw   Exception();
    }
  }

  @override
  Future<Party> getPartysById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final party = PartyMapper.jsonToEntity(response.data);
      return party;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) throw PartyNotFound();

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Party>> getPartysByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Party> partys = [];

    for (var party in response.data ?? []) {
      partys.add(PartyMapper.jsonToEntity(party));
    }

    return partys;
  }

  @override
  Future<List<Party>> searchPartyByTerm(String term) {
    // TODO: implement searchPartyByTerm
    throw UnimplementedError();
  }
}
