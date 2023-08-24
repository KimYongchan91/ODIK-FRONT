import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';

class RouteCart extends StatefulWidget {
  const RouteCart({super.key});

  @override
  State<RouteCart> createState() => _RouteCartState();
}

class _RouteCartState extends State<RouteCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyApp.providerCart),
        ],
        builder: (context, child) => SafeArea(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
