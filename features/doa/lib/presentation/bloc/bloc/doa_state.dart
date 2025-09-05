part of 'doa_bloc.dart';

class DoaState extends Equatable {
  final bool isLoading;
  final List<DoaEntity>? dataDoa;
  final String errorMessage;

  const DoaState({
    this.isLoading = false,
    this.dataDoa,
    this.errorMessage = '',
  });

  DoaState copyWith({
    bool? isLoading,
    List<DoaEntity>? dataDoa,
    String? errorMessage,
  }) {
    return DoaState(
      isLoading: isLoading ?? this.isLoading,
      dataDoa: dataDoa ?? this.dataDoa,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, dataDoa];
}
