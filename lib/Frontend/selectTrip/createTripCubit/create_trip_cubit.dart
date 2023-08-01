import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_trip_state.dart';

class CreateTripCubit extends Cubit<CreateTripState> {
  CreateTripCubit() : super(const CreateTripState());

  void setName(String newName){
    emit(state.copyWith(name: newName));
  }

  void setValuePerDay(int newValuePerDay){
    emit(state.copyWith(valuePerDay: newValuePerDay));
  }
}
