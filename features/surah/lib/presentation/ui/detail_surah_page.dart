import 'package:flutter/material.dart';
// import 'package:shared/common/utils/color_palettes.dart';
// import 'package:flutter_modular/flutter_modular.dart';
import 'package:surah/common/convertStringHtml.dart';
import 'package:surah/domain/entities/surah_entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surah/presentation/bloc/detail_surah/bloc/detail_surah_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

class DetailSurahPage extends StatefulWidget {
  final SurahEntity surahEntity;
  const DetailSurahPage({super.key, required this.surahEntity});

  @override
  State<DetailSurahPage> createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  late AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  @override
  void initState() {
    BlocProvider.of<DetailSurahBloc>(
      context,
    ).add(GetDetailSurah(numberOfSurah: widget.surahEntity.nomor));
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop saat keluar dari halaman
    _audioPlayer.dispose();
    super.dispose();
  }

  void playAudio() async {
    final url = widget.surahEntity.audio ?? ''; // URL audio dari entity
    if (url.isNotEmpty) {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        isPlaying = true;
      });
    }
  }

  void stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final _colorPalettes = Modular.get<ColorPalettes>();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.surahEntity.namaLatin}'),
        actions: [
          IconButton(
            icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
            onPressed: isPlaying ? stopAudio : playAudio,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/quran5.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    removeHtmlTags(widget.surahEntity.deskripsi ?? ''),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<DetailSurahBloc, DetailSurahState>(
                builder: (context, state) {
                  if (state.isLoading == true) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state.dataAyat != null) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.dataAyat?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/bgnumber.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              // fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Text(
                                        '${state.dataAyat?[index].ar}',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(fontSize: 25),
                                        softWrap: true, // pastikan ini true
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                Text(
                                  '${state.dataAyat?[index].tr}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${state.dataAyat?[index].idn}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
