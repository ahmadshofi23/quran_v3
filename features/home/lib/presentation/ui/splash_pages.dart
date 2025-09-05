import 'package:flutter/material.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPages extends StatelessWidget {
  const SplashPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _namedRoutes = Modular.get<NamedRoutes>();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
                child: Image.asset(
              'assets/quran1.png',
              height: height * 0.25,
            )),
            SizedBox(
              height: height * 0.013,
            ),
            const Text(
              'My Quran',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9543FF)),
            ),
            const Text(
              'Baca Al-Quran Degan Mudah',
              style: TextStyle(fontSize: 15, color: Color(0xffA8A8A8)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Modular.to.pushNamed(
                  _namedRoutes.home),
              child: Container(
                  // height: height * 0.07,
                  // width: width * 0.6,
                  decoration: BoxDecoration(
                    color: const Color(0xff9543FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.03),
                    child: const Center(
                      child: Text(
                        'Baca Sekarang',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFFFFFF)),
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: height * 0.05,
            ),
          ],
        ),
      ),
    ));
  }
}
