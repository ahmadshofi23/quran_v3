import 'package:flutter/material.dart';
import 'tab_item.dart';

class TabSelector extends StatelessWidget {
  final int selectedIndex;
  final double width;
  final ValueChanged<int>? onTap;

  const TabSelector({
    super.key,
    required this.selectedIndex,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Daftar tab bisa kamu ubah dengan mudah di sini
    final List<String> tabs = ['SURAT', 'DOA', 'Asmaul Husna', 'Hadist'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: width * 0.05),
            child: TabItem(
              label: tabs[index],
              index: index,
              isSelected: selectedIndex == index,
              width: width * 0.25, // bisa disesuaikan
              onTap: onTap,
            ),
          );
        }),
      ),
    );
  }
}
