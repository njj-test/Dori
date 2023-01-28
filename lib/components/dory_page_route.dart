import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder{
  final Widget page;

  FadePageRoute({required this.page})
      : super(
        pageBuilder: (
          context,
          animation,
          secondartAnimation,
        ) =>
            page,
        transitionsBuilder: (
          context,
          animation,
          secondartAnimation,
          child,
        ) =>
            FadeTransition(
          opacity: animation,
          child: child,
            ),
      );
}