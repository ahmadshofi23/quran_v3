part of 'asmaul_husna_bloc.dart';

class AsmaulHusnaState extends Equatable {
  final bool isLoading;
  final List<AsmaulhusnaEntity>? dataDoa;
  final String errorMessage;

  const AsmaulHusnaState({
    this.isLoading = false,
    this.dataDoa,
    this.errorMessage = '',
  });

  AsmaulHusnaState copyWith({
    bool? isLoading,
    List<AsmaulhusnaEntity>? dataDoa,
    String? errorMessage,
  }) {
    return AsmaulHusnaState(
      isLoading: isLoading ?? this.isLoading,
      dataDoa: dataDoa ?? this.dataDoa,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, dataDoa];
}
