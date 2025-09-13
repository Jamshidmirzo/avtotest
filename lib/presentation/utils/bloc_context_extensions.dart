import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocContextExtension on BuildContext {
  T bloc<T extends StateStreamableSource<Object?>>() => read<T>();

  T watchBloc<T extends StateStreamableSource<Object?>>() => watch<T>();

  void dispatch<E, B extends Bloc<E, Object>>(E event) {
    read<B>().add(event);
  }

  B cubit<B extends Cubit<Object>>() => read<B>();

  void addBlocEvent<T extends Bloc<Object?, dynamic>>(Object event) {
    read<T>().add(event);
  }
}