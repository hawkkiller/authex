import 'package:flutter_bloc/flutter_bloc.dart';

mixin StateSetterMixin<T> on Emittable<T> {
  void setState(T state) => emit(state);
}
