// location_event.dart
import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class StartLocationTracking extends LocationEvent {}

class StopLocationTracking extends LocationEvent {}

class LocationUpdated extends LocationEvent {
  final String? city;
  final String? error;

  const LocationUpdated({this.city, this.error});

  @override
  List<Object> get props => [city ?? '', error ?? ''];
}
