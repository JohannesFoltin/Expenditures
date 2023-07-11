
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenditures/Backend/repo/repo.dart';

import '../../../Backend/api/models/trip.dart';

part 'trip_overview_event.dart';
part 'trip_overview_state.dart';

class TripOverviewBloc extends Bloc<TripOverviewEvent, TripOverviewState> {
  TripOverviewBloc({required Trip trip,required Repo repo})
      : _repository = repo, super(TripOverviewState(trip: trip)) {
  }

  final Repo _repository;

}
