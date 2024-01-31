// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';


class _NoteInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;

  const _NoteInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: Colors.white,
        fontSize: maxLines != 1 ? 15.0 : 19.0,
        fontWeight: maxLines != 1 ? FontWeight.w400 : FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF9B9B9B),
          fontSize: maxLines != 1 ? 15.0 : 19.0,
          fontWeight: maxLines != 1 ? FontWeight.w400 : FontWeight.bold,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }
}
