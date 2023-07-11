import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/api/models/trip.dart';

part 'trip_overview_state.dart';

class TripOverviewCubit extends Cubit<TripOverviewState> {
  TripOverviewCubit({required Trip trip})
      : super(TripOverviewState(trip: trip));

  void setTab(HomeTab tab) => emit(state.copyWith(tab: tab));

}
