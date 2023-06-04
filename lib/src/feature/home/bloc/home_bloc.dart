import 'package:authex/src/feature/home/data/home_repository.dart';
import 'package:authex/src/feature/home/model/rick_n_morty_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class HomeState {
  const HomeState();

  RickNMortyEntity? get entity => switch (this) {
        final HomeSuccess state => state.entity,
        _ => null,
      };
}

class HomeIdle extends HomeState {
  const HomeIdle();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  const HomeSuccess(this.entity);

  @override
  final RickNMortyEntity entity;
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}

sealed class HomeEvent {
  const HomeEvent();
}

class HomeEventLoad extends HomeEvent {
  const HomeEventLoad(this.id);

  final int id;
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeIdle()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        final HomeEventLoad event => _load(event, emit),
      },
    );
  }

  final IHomeRepository _repository;

  Future<void> _load(HomeEventLoad event, Emitter<HomeState> emitter) async {
    emitter(const HomeLoading());
    try {
      final entity = await _repository.loadCharacter(event.id);
      emitter(HomeSuccess(entity));
    } on Object catch (error) {
      emitter(HomeError(error.toString()));
      rethrow;
    }
  }
}
