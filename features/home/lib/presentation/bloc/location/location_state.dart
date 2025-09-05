// location_state.dart
import 'package:equatable/equatable.dart';

class LocationState extends Equatable {
  final String? city;
  final bool loading;
  final String? error;

  const LocationState({this.city, this.loading = false, this.error});

  LocationState copyWith({String? city, bool? loading, String? error}) {
    return LocationState(
      city: city ?? this.city,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [city, loading, error];
}
