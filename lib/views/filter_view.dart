import 'package:flutter/material.dart';

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter")),
      body: Column(
        children: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop("elso");
            },
            child: const Text("elso"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop("masodik");
            },
            child: const Text("masodik"),
          ),
        ],
      ),
    );
  }
}
