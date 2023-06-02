import 'dart:math';

import 'package:authex/src/core/utils/extensions/context_extension.dart';
import 'package:authex/src/feature/auth/widget/auth_scope.dart';
import 'package:authex/src/feature/home/bloc/home_bloc.dart';
import 'package:authex/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _bloc;

  @override
  void initState() {
    _bloc = HomeBloc(DependenciesScope.repositoriesOf(context).homeRepository)
      ..add(
        const HomeEventLoad(1),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeBloc, HomeState>(
        bloc: _bloc,
        builder: (context, state) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _bloc.add(HomeEventLoad(Random().nextInt(826))),
            child: const Icon(Icons.swap_horizontal_circle),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Text(
                          context.stringOf().welcome_message,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => AuthScope.of(context).signOut(),
                              child: Text(context.stringOf().sign_out),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        context.stringOf().welcome_message_description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 46),
                    //   child: Text(
                    //     context.stringOf().you_are_authenticated,
                    //     style: Theme.of(context).textTheme.titleLarge,
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    if (state.entity != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            state.entity!.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Image.network(
                          state.entity!.image,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
