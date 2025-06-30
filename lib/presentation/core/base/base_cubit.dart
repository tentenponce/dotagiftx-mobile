import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  Object? arguments;

  BaseCubit(super.initialState) {
    init();
  }

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> init();
}
