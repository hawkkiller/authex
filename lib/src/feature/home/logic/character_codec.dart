import 'dart:convert';

import 'package:authex/src/feature/home/model/rick_n_morty_dto.dart';

final class CharacterCodec with Codec<RickNMortyDto, String> {
  const CharacterCodec();

  @override
  Converter<String, RickNMortyDto> get decoder => const _CharacterDecoder();

  @override
  Converter<RickNMortyDto, String> get encoder => const _CharacterEncoder();
}

final class _CharacterDecoder with Converter<String, RickNMortyDto> {
  const _CharacterDecoder();

  @override
  RickNMortyDto convert(String input) {
    final json = jsonDecode(input) as Map<String, Object?>;
    return RickNMortyDto(
      id: json['id']! as int,
      name: json['name']! as String,
      status: json['status']! as String,
      species: json['species']! as String,
      type: json['type']! as String,
      gender: json['gender']! as String,
      image: json['image']! as String,
    );
  }
}

final class _CharacterEncoder with Converter<RickNMortyDto, String> {
  const _CharacterEncoder();

  @override
  String convert(RickNMortyDto input) => jsonEncode({
        'id': input.id,
        'name': input.name,
        'status': input.status,
        'species': input.species,
        'type': input.type,
        'gender': input.gender,
        'image': input.image,
      });
}
