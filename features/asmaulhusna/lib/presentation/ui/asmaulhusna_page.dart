import 'package:asmaulhusna/presentation/bloc/bloc/asmaul_husna_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AsmaulhusnaPage extends StatefulWidget {
  const AsmaulhusnaPage({super.key});

  @override
  State<AsmaulhusnaPage> createState() => _AsmaulhusnaPageState();
}

class _AsmaulhusnaPageState extends State<AsmaulhusnaPage> {
  @override
  void initState() {
    BlocProvider.of<AsmaulHusnaBloc>(context).add(FetchAsmaulHusnaEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<AsmaulHusnaBloc, AsmaulHusnaState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        }
        if (state.dataDoa != null) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            itemCount: state.dataDoa!.length,
            separatorBuilder:
                (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  indent: 8,
                  endIndent: 8,
                ),
            itemBuilder: (context, index) {
              final asmaul = state.dataDoa![index];
              final number = index + 1;

              return Card(
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
                              asmaul.latin.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff240F4F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              asmaul.indo.toString(),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff240F4F),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tulisan arab
                      Text(
                        asmaul.arab.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff863ED5),
                        ),
                      ),
                    ],
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
