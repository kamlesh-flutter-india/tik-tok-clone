// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/_core/theme_config.dart';


class LoadingSpinner {
  SpinKitFadingCircle fadingCircleSpinner = const SpinKitFadingCircle(
    // size: 14,
    color: Colors.white,
  );

  SpinKitFadingCircle miniFadingCircleSpinner = const SpinKitFadingCircle(
    size: 22,
    color: Colors.white,
  );

  SpinKitThreeBounce horizontalLoading = const SpinKitThreeBounce(
    size: 14,
    color: AppTheme.buttonColor,
  );
}
