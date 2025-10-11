import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadist/presentation/ui/hadist_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Feature imports
import 'package:asmaulhusna/presentation/ui/asmaulhusna_page.dart';
import 'package:doa/presentation/ui/doa_pages.dart';
import 'package:surah/presentation/ui/surah_page.dart';
import 'package:home/presentation/widget/tab_selector.dart';
import 'package:home/utils/clean_name.dart';

// Bloc imports
import 'package:home/presentation/bloc/home/home_bloc.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'package:home/presentation/bloc/home/home_state.dart';
import 'package:home/presentation/bloc/location/location_bloc.dart';
import 'package:home/presentation/bloc/location/location_state.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  String? _lastAzanNotified;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeNotification();
    _tabController.addListener(() {
      setState(() => _selectedIndex = _tabController.index);
    });
  }

  Future<void> _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotificationAzan(String prayerName) async {
    // Pilih suara sesuai nama salat
    final String soundName =
        prayerName.toLowerCase() == 'subuh'
            ? 'azan_subuh' // file: assets/sounds/azan_subuh.mp3
            : 'azan_normal'; // file: assets/sounds/azan.mp3

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'azan_channel_id',
          'Azan Notifications',
          channelDescription: 'Pemberitahuan waktu salat harian',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(soundName),
          enableVibration: true,
          visibility: NotificationVisibility.public,
          styleInformation: const DefaultStyleInformation(true, true),
          category:
              AndroidNotificationCategory
                  .alarm, // agar bisa menembus Do Not Disturb
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Gunakan ID unik untuk tiap notifikasi supaya tidak tumpang tindih
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Waktu $prayerName Telah Tiba',
      'Sudah masuk waktu salat $prayerName, yuk segera salat 🙏',
      platformChannelSpecifics,
    );
  }

  void _showAzanDialog(BuildContext context, String prayerName) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.deepPurple[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              'Waktu $prayerName Telah Tiba',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Sudah masuk waktu salat, yuk segera salat dulu 🙏',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<HomeBloc, HomeState>(
        listenWhen:
            (previous, current) => previous.waktuAktif != current.waktuAktif,
        listener: (context, state) {
          if (state.waktuAktif != null &&
              state.waktuAktif != _lastAzanNotified) {
            _lastAzanNotified = state.waktuAktif;
            _showAzanDialog(context, state.waktuAktif!);
            _showNotificationAzan(state.waktuAktif!);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
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
                          const SizedBox(height: 8),

                          // JAM DAN INFO SALAT
                          BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              final now = state.currentTime ?? DateTime.now();
                              final jam = now.hour.toString().padLeft(2, '0');
                              final menit = now.minute.toString().padLeft(
                                2,
                                '0',
                              );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$jam:$menit',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Waktu aktif: ${state.waktuAktif ?? '-'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Berikutnya: ${state.waktuSalatBerikutnya ?? '-'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Menuju ${state.waktuSalatBerikutnya ?? '-'}: ${state.countdown ?? '--:--:--'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 10),
                          _buildLocationAndPrayerCard(),

                          // 🔔 Tombol Tes Azan
                        ],
                      ),
                    ),
                    Expanded(child: Image.asset('assets/quran4.png')),
                  ],
                ),

                SizedBox(height: height * 0.02),

                // TAB SELECTOR
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: height * 0.02),

                TabSelector(
                  selectedIndex: _selectedIndex,
                  width: width,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                      _tabController.animateTo(index);
                    });
                  },
                ),

                SizedBox(height: height * 0.02),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      SurahPage(),
                      DoaPage(),
                      AsmaulhusnaPage(),
                      HadistPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationAndPrayerCard() {
    return BlocListener<LocationBloc, LocationState>(
      listenWhen: (previous, current) => previous.city != current.city,
      listener: (context, state) {
        if (state.city != null) {
          final cityName = cleanCityName(state.city!.toUpperCase());
          context.read<HomeBloc>().add(GetIdCity(cityName));
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.loading) {
            return const Text('Mendeteksi lokasi...');
          } else if (locationState.error != null) {
            return Text('Error: ${locationState.error}');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lokasi: ${locationState.city}',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, homeState) {
                  if (homeState.loading) {
                    return _buildShimmerLoading();
                  } else if (homeState.error != null) {
                    return _buildErrorState(homeState);
                  } else if (homeState.jadwalHarian == null) {
                    return const Text('Belum ada jadwal salat');
                  }

                  return _buildPrayerScheduleCard(homeState);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrayerScheduleCard(HomeState homeState) {
    final activeColor = _getColorForWaktu(homeState.waktuAktif);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [activeColor.withOpacity(0.9), Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: activeColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildSalatRow(
            'Imsak',
            homeState.jadwalHarian?.imsak,
            active: homeState.waktuAktif == 'Imsak',
          ),
          _buildSalatRow(
            'Subuh',
            homeState.jadwalHarian?.subuh,
            active: homeState.waktuAktif == 'Subuh',
          ),
          _buildSalatRow(
            'Dhuha',
            homeState.jadwalHarian?.dhuha,
            active: homeState.waktuAktif == 'Dhuha',
          ),
          _buildSalatRow(
            'Dzuhur',
            homeState.jadwalHarian?.dzuhur,
            active: homeState.waktuAktif == 'Dzuhur',
          ),
          _buildSalatRow(
            'Ashar',
            homeState.jadwalHarian?.ashar,
            active: homeState.waktuAktif == 'Ashar',
          ),
          _buildSalatRow(
            'Maghrib',
            homeState.jadwalHarian?.maghrib,
            active: homeState.waktuAktif == 'Maghrib',
          ),
          _buildSalatRow(
            'Isya',
            homeState.jadwalHarian?.isya,
            active: homeState.waktuAktif == 'Isya',
          ),
        ],
      ),
    );
  }

  Color _getColorForWaktu(String? waktu) {
    switch (waktu) {
      case 'Subuh':
        return Colors.blue.shade600;
      case 'Dzuhur':
        return Colors.orange.shade600;
      case 'Ashar':
        return Colors.teal.shade600;
      case 'Maghrib':
        return Colors.red.shade600;
      case 'Isya':
        return Colors.indigo.shade700;
      case 'Dhuha':
        return Colors.amber.shade700;
      default:
        return const Color(0xff763FBC);
    }
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: List.generate(7, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 80, height: 14, color: Colors.white),
                  Container(width: 60, height: 14, color: Colors.white),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildErrorState(HomeState homeState) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(height: 8),
          Text('Error: ${homeState.error}'),
          TextButton(
            onPressed: () {
              if (homeState.city != null) {
                context.read<HomeBloc>().add(GetIdCity(homeState.city!));
              }
            },
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }
}

Widget _buildSalatRow(String label, String? time, {bool active = false}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
    decoration: BoxDecoration(
      color: active ? Colors.white.withOpacity(0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          time ?? '-',
          style: TextStyle(
            fontSize: 14,
            color: active ? Colors.yellowAccent : Colors.white,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
