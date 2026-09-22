

import 'package:flutter/material.dart';

import 'app_info.dart';

/// The XPENC mark, drawn rather than shipped as an asset.
///
/// The geometry below is the same definition `tool/generate_icons.py` rasterises
/// into the launcher icons — the numbers are duplicated, not shared, because one
/// side is Python and the other Dart. If you change a constant here, change it
/// there too and re-run the generator, or the in-app logo and the home-screen
/// icon will quietly stop being the same shape.
///
/// Vector, so it stays sharp at any size and picks up the theme's colours; an
/// asset would need a light and a dark copy at five densities.


/// A squircle tile with the X knocked into it.
///
/// Defaults invert with the theme — a black tile in light mode, a white tile in
/// dark — so the mark always sits at full contrast against the page. Pass [tile]
/// and [ink] to force the true brand colours instead (see [BrandMark.icon]).
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = 40,
    this.tile,
    this.ink,
    this.radiusRim = true,
  });

  /// The literal launcher icon: near-black tile, white X, hairline rim.
  const BrandMark.icon({super.key, this.size = 40})
      : tile = const Color(0xFF0E0E10),
        ink = Colors.white,
        radiusRim = true;

  final double size;
  final Color? tile;
  final Color? ink;

  /// A faint edge so a black tile stays visible on a black page.
  final bool radiusRim;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.asset(
          'assets/images/appicon.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}



/// `XPENC`, set the way the brand sets it: heavy, tight, all caps.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.fontSize = 26, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppInfo.name,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: fontSize * 0.06,
        height: 1.1,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Mark and wordmark locked together, for headers and the About screen.
class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, this.markSize = 34, this.fontSize = 24});

  final double markSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(size: markSize),
        SizedBox(width: markSize * 0.34),
        BrandWordmark(fontSize: fontSize),
      ],
    );
  }
}
