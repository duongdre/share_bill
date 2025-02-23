/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart' as _lottie;

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/faceIdAnimation.json
  LottieGenImage get faceIdAnimation => const LottieGenImage('assets/animations/faceIdAnimation.json');

  /// List of all assets
  List<LottieGenImage> get values => [faceIdAnimation];
}

class $AssetsColorsGen {
  const $AssetsColorsGen();

  /// File path: assets/colors/colors.xml
  String get colors => 'assets/colors/colors.xml';

  /// List of all assets
  List<String> get values => [colors];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/raleway-extralight.ttf
  String get ralewayExtralight => 'assets/fonts/raleway-extralight.ttf';

  /// File path: assets/fonts/raleway-light.ttf
  String get ralewayLight => 'assets/fonts/raleway-light.ttf';

  /// List of all assets
  List<String> get values => [ralewayExtralight, ralewayLight];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/shield_with_checkmark_icons.png
  AssetGenImage get shieldWithCheckmarkIcons => const AssetGenImage('assets/icons/shield_with_checkmark_icons.png');

  /// List of all assets
  List<AssetGenImage> get values => [shieldWithCheckmarkIcons];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/acbOneColors.png
  AssetGenImage get acbOneColors => const AssetGenImage('assets/images/acbOneColors.png');

  /// File path: assets/images/acbOneWhite.png
  AssetGenImage get acbOneWhite => const AssetGenImage('assets/images/acbOneWhite.png');

  /// File path: assets/images/bgLogin.png
  AssetGenImage get bgLogin => const AssetGenImage('assets/images/bgLogin.png');

  /// File path: assets/images/faceId.png
  AssetGenImage get faceId => const AssetGenImage('assets/images/faceId.png');

  /// File path: assets/images/grid_bg.png
  AssetGenImage get gridBg => const AssetGenImage('assets/images/grid_bg.png');

  /// File path: assets/images/homeFake.png
  AssetGenImage get homeFake => const AssetGenImage('assets/images/homeFake.png');

  /// File path: assets/images/loginCard1.png
  AssetGenImage get loginCard1 => const AssetGenImage('assets/images/loginCard1.png');

  /// File path: assets/images/loginCard2.png
  AssetGenImage get loginCard2 => const AssetGenImage('assets/images/loginCard2.png');

  /// File path: assets/images/loginCard3.png
  AssetGenImage get loginCard3 => const AssetGenImage('assets/images/loginCard3.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/splashAcb.png
  AssetGenImage get splashAcb => const AssetGenImage('assets/images/splashAcb.png');

  /// List of all assets
  List<AssetGenImage> get values => [acbOneColors, acbOneWhite, bgLogin, faceId, gridBg, homeFake, loginCard1, loginCard2, loginCard3, logo, splashAcb];
}

class Assets {
  Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsColorsGen colors = $AssetsColorsGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class LottieGenImage {
  const LottieGenImage(
    this._assetName, {
    this.flavors = const {},
  });

  final String _assetName;
  final Set<String> flavors;

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(
      BuildContext,
      Widget,
      _lottie.LottieComposition?,
    )? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
