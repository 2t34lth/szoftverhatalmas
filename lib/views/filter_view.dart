import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/views/category_view.dart';
import 'package:hardverapro_a_kezedben/views/search_view.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key, this.filter});
  final Filter? filter;

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  Filter _filter = Filter();

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
  void initState() {
    super.initState();
    if (widget.filter != null) _filter = widget.filter!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(_filter);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
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
      ),
    );
  }
}
