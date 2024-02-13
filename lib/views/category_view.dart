import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/search_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final List<Category> _categories = [
    Category(name: "Hardver", path: "hardver"),
    Category(name: "Notebook", path: "notebook"),
    Category(name: "PC, szerver", path: "pc_szerver"),
    Category(name: "Mobil, tablet", path: "mobil"),
    Category(name: "Konzol", path: "szoftver_jatek"),
    Category(name: "TV-audió", path: "hazimozi_hifi"),
    Category(name: "Fotó-videó", path: "foto_video"),
    Category(name: "Egyéb", path: "egyeb"),
  ];
  List<Category> _subcategories = [];
  Category? _category;
  LoadingState _state = LoadingState.ready;

  void _updateCategories(Category c) {
    _category = c;
    setState(() {
      _state = LoadingState.processing;
    });
    Hardverapro.getCategories(_category!.path).then((categories) {
      if (categories.isEmpty) {
        Navigator.of(context).pop(_category);
        return;
      } else {
        setState(() {
          _subcategories = categories;
        });
      }
    }).whenComplete(() => _state = LoadingState.ready);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category")),
      body: Builder(builder: (context) {
        if (_state == LoadingState.processing) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_subcategories.isEmpty) {
          return ListView(
            children: _categories
                .map(
                  (Category e) => ListTile(
                    title: Text(e.name),
                    onTap: () => _updateCategories(e),
                  ),
                )
                .toList(),
          );
        }
        return ListView(children: [
          ListTile(
            title: Text("All ${_category?.name}"),
            onTap: () {
              Navigator.of(context).pop(_category);
            },
          ),
          ..._subcategories.map((e) => ListTile(
                title: Text(e.name),
                onTap: () => _updateCategories(e),
              ))
        ]);
      }),
    );
  }
}
