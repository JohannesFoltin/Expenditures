part of 'create_trip_cubit.dart';

class CreateTripState extends Equatable {

  const CreateTripState({
     this.name = '',
     this.valuePerDay = 0,
  });

  final String name;
  final int valuePerDay;

  @override
  List<Object?> get props => [name,valuePerDay];

  CreateTripState copyWith({
    String? name,
    int? valuePerDay,
  }) {
    return CreateTripState(
      name: name ?? this.name,
      valuePerDay: valuePerDay ?? this.valuePerDay,
    );
  }
}


