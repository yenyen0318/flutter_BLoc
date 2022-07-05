import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mybloc_event.dart';
part 'mybloc_state.dart';

class MyblocBloc extends Bloc<MyblocEvent, MyblocState> {
  MyblocBloc() : super(MyblocInitial()) {
    on<MyblocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
