import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:surah/presentation/bloc/bloc/quran_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:surah/domain/entities/surah_entities.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuranBloc>(context).add(GetAllSurah());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state.isLoading == true) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.dataSurah != null && state.dataSurah!.isNotEmpty) {
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(
              state.dataSurah!.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    Modular.to.pushNamed(
                      '${_namedRoutes.surah}${_namedRoutes.detailSurah}',
                      arguments: state.dataSurah![index],
                    );
                  },
                  child: CardSurat(
                    height: height,
                    width: width,
                    surahEntity: state.dataSurah![index],
                  ),
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

class CardSurat extends StatelessWidget {
  CardSurat({
    // super.key,
    required this.height,
    required this.width,
    required this.surahEntity,
  });

  final double height;
  final double width;
  final SurahEntity surahEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height * 0.07,
          width: 7,
          decoration: BoxDecoration(
            color: const Color(0xff9543FF),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(width: width * 0.04),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffFCFCFC),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/bgnumber.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          surahEntity.nomor.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.016),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surahEntity.namaLatin.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff240F4F),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Jumlah Ayat :',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8789A3),
                              ),
                            ),
                            SizedBox(width: width * 0.014),
                            Text(
                              '${surahEntity.jumlahAyat}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8789A3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${surahEntity.nama}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff863ED5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
