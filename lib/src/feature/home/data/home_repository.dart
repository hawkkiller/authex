import 'package:authex/src/feature/home/data/home_data_provider.dart';
import 'package:authex/src/feature/home/model/rick_n_morty_entity.dart';

abstract interface class IHomeRepository {
  Future<RickNMortyEntity> loadCharacter(int id);
}

final class HomeRepository implements IHomeRepository {
  const HomeRepository(this._dataProvider);

  final IHomeDataProvider _dataProvider;

  @override
  Future<RickNMortyEntity> loadCharacter(int id) async {
    final character = await _dataProvider.loadCharacter(id);
    return RickNMortyEntity(
      gender: character.gender,
      id: character.id,
      image: character.image,
      name: character.name,
      species: character.species,
      status: character.status,
      type: character.type,
    );
  }
}
