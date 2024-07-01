
import 'package:flutter/material.dart';


class textFieldTitle extends StatelessWidget {
  final String title;
  const textFieldTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: const Color(0xFF7C7E8C), fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}