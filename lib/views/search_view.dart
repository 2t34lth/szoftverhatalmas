import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/filter_view.dart';
import 'package:hardverapro_a_kezedben/widgets/search_result.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

enum LoadingState {
  processing,
  ready,
}

class Filter {
  Category? category;

  Filter({this.category});
}

class _SearchViewState extends State<SearchView> {
  List<HardveraproPost> _posts = [];
  final _searchQuery = TextEditingController();
  LoadingState _state = LoadingState.processing;
  Filter? _filter;

  void _setFilter() {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) {
        return FilterView(filter: _filter);
      },
    )).then((r) {
      if (r != null) {
        setState(() {
          _filter = r;
        });

        _search();
      }
    });
  }

  void _search() {
    setState(() {
      _posts = [];
      _state = LoadingState.processing;
    });
    Hardverapro.search(
      _searchQuery.text,
      category: _filter?.category,
    ).then((posts) {
      setState(() {
        _posts = posts;
      });
    }).whenComplete(
      () => setState(() {
        _state = LoadingState.ready;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    Hardverapro.homePosts().then((posts) {
      setState(() {
        _posts = posts;
        _state = LoadingState.ready;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
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
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _setFilter,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_state == LoadingState.processing) {
            return const Center(child: CircularProgressIndicator());
          } else if (_posts.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "No results found",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _posts.map((el) {
                  return SearchResult(post: el);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
