import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadist/presentation/bloc/bloc/hadist_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/utils/named_routes.dart';

class HadistPage extends StatefulWidget {
  const HadistPage({super.key});

  @override
  State<HadistPage> createState() => _HadistPageState();
}

class _HadistPageState extends State<HadistPage> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<HadistBloc>(context).add(FetchHadistEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final _namedRoutes = Modular.get<NamedRoutes>();

    return BlocBuilder<HadistBloc, HadistState>(
      builder: (context, state) {
        if (state is HadistLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HadistError) {
          return Center(child: Text(state.message));
        }
        if (state is HadistLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            itemCount: state.hadist.length,
            separatorBuilder:
                (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  indent: 8,
                  endIndent: 8,
                ),
            itemBuilder: (context, index) {
              final hadist = state.hadist[index];
              final number = index + 1;

              return GestureDetector(
                onTap: () {
                  Modular.to.pushNamed(
                    '${_namedRoutes.hadist}${_namedRoutes.detailHadist}',
                    arguments: hadist,
                  );
                  // Navigator.pushNamed(context, '/detailHadist', arguments: hadist);
                },
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.zero, // biar rapi, rely on Divider
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nomor urut
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
                              number.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.04),

                        // Expanded supaya teks wrap otomatis
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hadist.judul.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff240F4F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   hadist.indo.toString(),
                              //   softWrap: true,
                              //   overflow: TextOverflow.visible,
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w400,
                              //     color: Color(0xff240F4F),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        // Tulisan arab
                        // Text(
                        //   asmaul.arab.toString(),
                        //   textAlign: TextAlign.right,
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xff863ED5),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No Data'));
      },
    );
  }
}
