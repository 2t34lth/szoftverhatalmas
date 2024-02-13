import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/category_view.dart';
import 'package:hardverapro_a_kezedben/views/search_view.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  Category? _category;

  void _setCategory() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const CategoryView();
      },
    )).then((value) {
      setState(() {
        _category = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_category?.name ?? "No category"),
                FilledButton(
                  onPressed: _setCategory,
                  child: const Text("Select category"),
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  Filter(
                    category: _category,
                  ),
                );
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
