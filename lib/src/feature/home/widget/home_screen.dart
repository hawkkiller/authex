import 'dart:math';

import 'package:authex/src/core/assets/generated/assets.gen.dart';
import 'package:authex/src/core/utils/extensions/context_extension.dart';
import 'package:authex/src/feature/auth/widget/auth_scope.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StateMachineController _controller;
  late final SMITrigger _toggle;

  void _onInit(Artboard art) {
    _controller = StateMachineController.fromArtboard(
      art,
      'State Machine 1',
    )!;
    art.addController(_controller);
    _toggle = _controller.findInput<bool>('toggle')! as SMITrigger;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _toggle.fire(),
          child: const Icon(Icons.swap_horizontal_circle),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  context.stringOf().welcome_message,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    context.stringOf().welcome_message_description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 46),
                  child: Text(
                    context.stringOf().you_are_authenticated,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => AuthScope.of(context).signOut(),
                      child: Text(context.stringOf().sign_out),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    height: min(500, MediaQuery.of(context).size.height),
                    width: min(500, MediaQuery.of(context).size.height),
                    child: RiveAnimation.asset(
                      Assets.rive.sith.path,
                      onInit: _onInit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
