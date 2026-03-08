import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, int> {
  DashboardBloc() : super(0) {
    on<PageChangedEvent>((event, emit) {
      emit(event.index);
    });
  }
}
