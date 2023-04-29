import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final Widget? child;

  const LoadingWidget({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size deviceSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Center(heightFactor: double.infinity, widthFactor: double.infinity, child: child),
        GlassMorphism(
          child: SpinKitFadingCircle(
            color: Theme.of(context).primaryColor,
            size: 80.0,
          ),
        )
      ],
    );
  }
}

class GlassMorphism extends StatelessWidget {
  final Widget? child;

  // final double start;
  // final double end;

  const GlassMorphism({
    Key? key,
    this.child,
    // required this.start,
    // required this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          // decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          child: child,
        ),
      ),
    );
  }
}
