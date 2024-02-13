import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/views/category_view.dart';
import 'package:hardverapro_a_kezedben/views/search_view.dart';

class FilterView extends StatefulWidget {
  final Filter? filter;
  const FilterView({super.key, this.filter});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  late Filter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.filter ?? Filter();
  }

  void _setCategory() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const CategoryView();
      },
    )).then((value) {
      setState(() {
        _filter.category = value;
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_filter.category?.name ?? "No category"),
                    FilledButton(
                      onPressed: _setCategory,
                      child: const Text("Select category"),
                    ),
                  ],
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  _filter,
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
