import 'package:flutter/material.dart';

class HomeSearch2 extends StatefulWidget {
  const HomeSearch2({super.key});

  @override
  State<HomeSearch2> createState() => _HomeSearch2State();
}

class _HomeSearch2State extends State<HomeSearch2> {
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

