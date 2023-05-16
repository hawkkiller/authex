import 'package:authex/src/feature/home/logic/character_codec.dart';
import 'package:authex/src/feature/home/model/rick_n_morty_dto.dart';
import 'package:http/http.dart' as http;

abstract interface class IHomeDataProvider {
  Future<RickNMortyDto> loadCharacter(int id);
}

final class HomeDataProvider implements IHomeDataProvider {
  const HomeDataProvider(this._client);

  final http.Client _client;

  @override
  Future<RickNMortyDto> loadCharacter(int id) async {
    final res = await _client.get(Uri.parse('https://rickandmortyapi.com/api/character/$id'));

    return const CharacterCodec().decode(res.body);
  }
}
