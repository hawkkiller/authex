import 'package:authex/src/feature/auth/widget/auth_scope.dart';
import 'package:flutter/material.dart';

class GlobalScopes extends StatelessWidget {
  const GlobalScopes({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => AuthScope(child: child);
}
