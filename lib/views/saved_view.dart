import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/product_view.dart';
import 'package:hardverapro_a_kezedben/views/search_view.dart';
import 'package:hardverapro_a_kezedben/widgets/search_result.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  GetStorage storage = GetStorage();
  List<HardveraproPost>? _savedPosts;
  LoadingState _state = LoadingState.processing;

  void _loadSavedPosts() {
    List<dynamic> savedUrls = GetStorage().read("saved_items") ?? [];

    Future.wait(savedUrls.map((e) async {
      final product = await Hardverapro.getPost(e);
      return HardveraproPost(
        title: product.title,
        price: product.price,
        location: product.location,
        imageUrl: "https:${product.images.first}",
        url: e,
        freezed: product.freezed,
        author: product.author,
      );
    })).then(
      (value) {
        setState(() {
          _savedPosts = value;
        });
      },
    ).whenComplete(() {
      setState(() {
        _state = LoadingState.ready;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved items"),
        elevation: 1,
      ),
      body: Builder(builder: (context) {
        if (_state == LoadingState.processing) {
          return const Center(child: CircularProgressIndicator());
        } else if (_savedPosts?.isEmpty ?? true) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "No saved items",
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: _savedPosts
                    ?.map<Widget>((el) => SearchResult(
                          post: el,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductView(
                                      url: el.url!,
                                    ),
                                  ),
                                )
                                .whenComplete(_loadSavedPosts);
                          },
                        ))
                    .toList() ??
                [],
          );
        }
      }),
    );
  }
}
