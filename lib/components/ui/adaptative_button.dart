// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const AdaptativeButton(
      {required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressed,
            color: Theme.of(context).textTheme.button!.color,
            child: Text(label))
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.button?.color,
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.button!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
