import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category")),
      body: Builder(builder: (context) {
        if (_subcategories.isEmpty) {
          return ListView(
              children: _categories
                  .map((e) => ListTile(
                        title: Text(e.name),
                        onTap: () {
                          _category = e;
                          Hardverapro.getCategories(_category!.path)
                              .then((categories) {
                            setState(() {
                              _subcategories = categories;
                            });
                          });
                        },
                      ))
                  .toList());
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
                onTap: () {
                  _category = e;
                  Hardverapro.getCategories(_category!.path).then((categories) {
                    if (categories.isEmpty) {
                      Navigator.of(context).pop(_category);
                      return;
                    } else {
                      setState(() {
                        _subcategories = categories;
                      });
                    }
                  });
                },
              ))
        ]);
      }),
    );
  }
}
