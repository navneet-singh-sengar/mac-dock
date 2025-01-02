import 'package:flutter/material.dart';

class DockIcon extends StatelessWidget {
  const DockIcon({required this.iconPath, super.key});

  final String iconPath;

  @override
  Widget build(final BuildContext context) {
    return Image.asset(
      iconPath,
      width: 50,
      height: 50,
    );
  }
}
