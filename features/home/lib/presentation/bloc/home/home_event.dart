import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetIdCity extends HomeEvent {
  final String city;

  const GetIdCity(this.city);

  @override
  List<Object> get props => [city];
}

class StartSalatTracking extends HomeEvent {}

class UpdateCurrentTime extends HomeEvent {}

class ShowAzanDialog extends HomeEvent {
  final String prayerName;
  const ShowAzanDialog(this.prayerName);

  @override
  List<Object> get props => [prayerName];
}
