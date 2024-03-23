import 'package:flutter/material.dart';

class VegetableSearch extends StatefulWidget {
  final TextEditingController  textEditingController;
  final Function(String) onSearchTextChanged;
  const VegetableSearch({super.key,required this.textEditingController,required this.onSearchTextChanged});

  @override
  State<VegetableSearch> createState() => _VegetableSearchState();
}

class _VegetableSearchState extends State<VegetableSearch> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      decoration: InputDecoration(
        hintText: 'Search Key ...',
        enabledBorder: customBorder(),
        focusedBorder: customBorder(),
        suffixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade400,
        ),
      ),
      onChanged: (value) {
        widget.onSearchTextChanged(value); // Gọi callback khi giá trị tìm kiếm thay đổi
      },
    );
  }

  OutlineInputBorder customBorder() => OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade400,
    ),
    borderRadius: BorderRadius.circular(10.0),
  );
}

