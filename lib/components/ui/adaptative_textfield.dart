import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType keyBoard;
  final Function(String)? onSubmitted;

  const AdaptativeTextField({
    this.label,
    this.controller,
    this.keyBoard = TextInputType.text,
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              keyboardType: keyBoard,
              onSubmitted: onSubmitted,
              controller: controller,
              placeholder: label,
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            keyboardType: keyBoard,
            onSubmitted: onSubmitted,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          );
  }
}
