// ignore_for_file: depend_on_referenced_packages

import 'package:doa/presentation/bloc/bloc/doa_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/utils/named_routes.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  @override
  void initState() {
    BlocProvider.of<DoaBloc>(context).add(FetchDoaEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _namedRoutes = Modular.get<NamedRoutes>();
    return BlocBuilder<DoaBloc, DoaState>(
      builder: (context, state) {
        if (state.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.dataDoa != null && state.dataDoa!.isNotEmpty) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(
              state.dataDoa!.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    Modular.to.pushNamed(
                      '${_namedRoutes.doa}${_namedRoutes.detailDoa}',
                      arguments: state.dataDoa![index],
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(state.dataDoa![index].judul ?? ''),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
