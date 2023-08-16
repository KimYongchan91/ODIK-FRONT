import 'package:flutter/material.dart';
import 'package:odik/const/value/admin.dart';

class ItemButtonAdminType extends StatelessWidget {
  final AdminType adminType;
  final bool isSelected;

  const ItemButtonAdminType({required this.adminType, required this.isSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: isSelected ? 2 : 1, color: isSelected ? Colors.orangeAccent : Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            getAdminName(adminType),
            style: TextStyle(
              color: isSelected ? Colors.orangeAccent : Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
