import 'package:flutter/material.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
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

