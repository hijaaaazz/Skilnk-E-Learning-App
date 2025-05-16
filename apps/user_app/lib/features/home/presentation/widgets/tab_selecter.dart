import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const TabSelector({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        tabs.length,
        (index) => Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? const Color(0xFFE8F1FF)
                    : const Color(0xFFF4F8FE),
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: const Color(0xFFE8F1FF),
                  ),
                  bottom: BorderSide(
                    width: 2,
                    color: const Color(0xFFE8F1FF),
                  ),
                  left: index == 0
                      ? BorderSide.none
                      : BorderSide(
                          width: 2,
                          color: const Color(0xFFE8F1FF),
                        ),
                  right: index == tabs.length - 1
                      ? BorderSide.none
                      : BorderSide.none,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: const Color(0xFF202244),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
