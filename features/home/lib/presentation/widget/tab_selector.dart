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
    return Row(
      children: [
        TabItem(
          label: 'SURAT',
          index: 0,
          isSelected: selectedIndex == 0,
          width: width * 0.2,
          onTap: onTap,
        ),
        SizedBox(width: width * 0.05),
        TabItem(
          label: 'DOA',
          index: 1,
          isSelected: selectedIndex == 1,
          width: width * 0.2,
          onTap: onTap,
        ),
        SizedBox(width: width * 0.05),
        TabItem(
          label: 'Asmaul Husna',
          index: 2,
          isSelected: selectedIndex == 2,
          onTap: onTap,
        ),
        SizedBox(width: width * 0.05),
        TabItem(
          label: 'Hadist',
          index: 3,
          isSelected: selectedIndex == 3,
          onTap: onTap,
        ),
      ],
    );
  }
}
