import 'package:asmaulhusna/presentation/ui/asmaulhusna_page.dart';
import 'package:doa/presentation/ui/doa_pages.dart';
import 'package:flutter/material.dart';
import 'package:home/presentation/bloc/home/home_bloc.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'package:home/presentation/bloc/home/home_state.dart';
import 'package:home/presentation/bloc/location/location_bloc.dart';
import 'package:home/presentation/bloc/location/location_state.dart';
import 'package:home/utils/clean_name.dart';
import 'package:surah/presentation/ui/surah_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Quran',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff9543FF),
                          ),
                        ),
                        const Text(
                          'Baca Al-Quran Dengan Mudah',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),

                        const Text(
                          '19:21',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Ramadan 23, 1444 AH',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff232323),
                          ),
                        ),
                        const SizedBox(height: 5),
                        BlocBuilder<LocationBloc, LocationState>(
                          builder: (context, state) {
                            if (state.loading) {
                              return const Text('Mendeteksi lokasi...');
                            } else if (state.error != null) {
                              return Text('Error: ${state.error}');
                            } else {
                              final cityName = cleanCityName(
                                '${state.city?.toUpperCase()}',
                              );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lokasi: ${state.city}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  BlocConsumer<HomeBloc, HomeState>(
                                    listener:
                                        (context, state) =>
                                            context.read<HomeBloc>()
                                              ..add(GetIdCity(cityName)),
                                    builder: (context, state) {
                                      if (state.loading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state.error != null) {
                                        return Text('Error: ${state.error}');
                                      }
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xff763FBC,
                                          ).withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              _buildSalatRow(
                                                'Imsak',
                                                '${state.jadwalHarian?.imsak}',
                                              ),
                                              _buildSalatRow(
                                                'Subuh',
                                                '${state.jadwalHarian?.subuh}',
                                              ),
                                              _buildSalatRow(
                                                'Dhuha',
                                                '${state.jadwalHarian?.dhuha}',
                                              ),
                                              _buildSalatRow(
                                                'Dzuhur',
                                                '${state.jadwalHarian?.dzuhur}',
                                              ),
                                              _buildSalatRow(
                                                'Ashar',
                                                '${state.jadwalHarian?.ashar}',
                                              ),
                                              _buildSalatRow(
                                                'Magrib',
                                                '${state.jadwalHarian?.maghrib}',
                                              ),
                                              _buildSalatRow(
                                                'Isya',
                                                '${state.jadwalHarian?.isya}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    listenWhen:
                                        (previous, current) =>
                                            previous.city != current.city,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Image.asset('assets/quran4.png')),
                ],
              ),

              // ... (bagian atas tetap sama)
              SizedBox(height: height * 0.01),

              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: height * 0.02),

              Row(
                children: [
                  Container(
                    width: width * 0.2,
                    decoration: BoxDecoration(
                      color:
                          _selectedIndex == 0
                              ? const Color(0xff9543FF)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _selectedIndex == 0
                                ? Colors.transparent
                                : Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'SURAT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                _selectedIndex == 0
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: width * 0.05),
                  Container(
                    width: width * 0.2,
                    decoration: BoxDecoration(
                      color:
                          _selectedIndex == 1
                              ? const Color(0xff9543FF)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _selectedIndex == 1
                                ? Colors.transparent
                                : Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'DOA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                _selectedIndex == 1
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: width * 0.05),
                  Container(
                    // width: width * 0.2,
                    decoration: BoxDecoration(
                      color:
                          _selectedIndex == 2
                              ? const Color(0xff9543FF)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _selectedIndex == 2
                                ? Colors.transparent
                                : Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          'Asmaul Husna',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                _selectedIndex == 2
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [SurahPage(), DoaPage(), AsmaulhusnaPage()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSalatRow(String label, String? time) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          time ?? '-',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    ),
  );
}
