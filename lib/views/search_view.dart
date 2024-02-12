import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/widgets/search_result.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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
                  return SearchResult(post: el);
                }).toList(),
              ),
            ),
    );
  }
}
