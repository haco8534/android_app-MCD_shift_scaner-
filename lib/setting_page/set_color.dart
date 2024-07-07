import 'package:flutter/material.dart';

class SetColor extends StatefulWidget {
  const SetColor({super.key});

  @override
  State<SetColor> createState() => _SetColor();
}

class _SetColor extends State<SetColor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            toolbarHeight: 50,
            title: const Text("編集"),
          ),
    );
  }
}
