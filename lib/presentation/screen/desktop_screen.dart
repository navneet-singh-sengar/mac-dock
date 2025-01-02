import 'package:dock/core/assets_constants.dart';
import 'package:dock/presentation/screen/mac_os_dock.dart';
import 'package:flutter/material.dart';


class DesktopScreen extends StatelessWidget {
  const DesktopScreen({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsConstants.wallpaper),
          fit: BoxFit.cover,
        ),
      ),
      child: MacOSDock(),
    );
  }
}
