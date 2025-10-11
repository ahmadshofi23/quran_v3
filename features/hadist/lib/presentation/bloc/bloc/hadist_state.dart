part of 'hadist_bloc.dart';

@immutable
sealed class HadistState {}

final class HadistInitial extends HadistState {}

final class HadistLoading extends HadistState {}

final class HadistLoaded extends HadistState {
  final List<HadistEntity> hadist;
  HadistLoaded(this.hadist);
}

final class HadistError extends HadistState {
  final String message;
  HadistError(this.message);
}
