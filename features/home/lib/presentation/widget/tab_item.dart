import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String label;
  final int index;
  final bool isSelected;
  final double? width;
  final ValueChanged<int>? onTap;

  const TabItem({
    required this.label,
    required this.index,
    required this.isSelected,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff9543FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
