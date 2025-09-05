part of 'detail_surah_bloc.dart';

class DetailSurahState extends Equatable {
  final bool isLoading;
  final List<AyatEntity>? dataAyat;
  final String errorMessage;

  const DetailSurahState({
    this.isLoading = false,
    this.dataAyat,
    this.errorMessage = '',
  });

  DetailSurahState copyWith({
    bool? isLoading,
    List<AyatEntity>? dataAyat,
    String? errorMessage,
  }) => DetailSurahState(
    isLoading: isLoading ?? this.isLoading,
    dataAyat: dataAyat ?? this.dataAyat,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [isLoading, dataAyat, errorMessage];
}
