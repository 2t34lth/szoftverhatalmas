import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/product_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // final _searchQuery = TextEditingController();
  List<HardveraproPost> _posts = [];
  final _searchQuery = TextEditingController();

  void _search() {
    setState(() {
      _posts = [];
    });
    Hardverapro.search(_searchQuery.text).then((posts) {
      setState(() {
        _posts = posts;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Hardverapro.homePosts().then((posts) {
      setState(() {
        _posts = posts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchQuery,
              elevation: const MaterialStatePropertyAll(1),
              hintText: "Search",
              onSubmitted: (q) => _search(),
              trailing: [
                IconButton(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                )
              ],
            ),
          ),
        ),
      ),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _posts.map((el) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ProductView(
                              url: el.url!,
                              title: el.title ?? "unknown title",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.network(
                            el.imageUrl!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  el.title ?? "unknown title",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      el.price ?? "unknown price",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          el.author.username ??
                                              "unknown author",
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          el.author.rating ??
                                              "(unknown rating)",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
