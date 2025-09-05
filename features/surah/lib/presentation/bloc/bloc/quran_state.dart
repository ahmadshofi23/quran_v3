part of 'quran_bloc.dart';

class QuranState extends Equatable {
  final bool isLoading;
  final List<SurahEntity>? dataSurah;
  final String errorMessage;

  const QuranState({
    this.isLoading = false,
    this.dataSurah,
    this.errorMessage = '',
  });

  QuranState copyWith({
    bool? isLoading,
    List<SurahEntity>? dataSurah,
    String? errorMessage,
  }) {
    return QuranState(
      isLoading: isLoading ?? this.isLoading,
      dataSurah: dataSurah ?? this.dataSurah,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, dataSurah];
}
