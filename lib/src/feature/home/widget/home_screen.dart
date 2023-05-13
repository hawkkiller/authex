import 'package:authex/src/core/utils/extensions/context_extension.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            context.stringOf().appTitle.toUpperCase(),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      );
}
