import 'package:flutter/material.dart';

class DichBenhSearch extends StatelessWidget {
  const DichBenhSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Key ...',
        enabledBorder: customBorder(),
        focusedBorder: customBorder(),
        suffixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  OutlineInputBorder customBorder() => OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade400,
    ),
    borderRadius: BorderRadius.circular(10.0),
  );
}

