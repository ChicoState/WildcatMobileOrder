import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Placeholder loading widget
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey[800],
        child: Center(
          child: SpinKitRotatingCircle(
            color: Colors.red[800],
            size: 50.0,
          ),
        ),
      );
}
