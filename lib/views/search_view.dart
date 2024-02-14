import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/filter_view.dart';
import 'package:hardverapro_a_kezedben/widgets/search_result.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

enum LoadingState {
  processing,
  loadingAdditional,
  ready,
}

class Filter {
  Category? category;
  int? minPrice;
  int? maxPrice;
  bool? hideFrozen;

  Filter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.hideFrozen,
  });
}

class _SearchViewState extends State<SearchView> {
  List<HardveraproPost> _posts = [];
  final _searchQuery = TextEditingController();
  LoadingState _state = LoadingState.processing;
  Filter? _filter;
  List<int> _offsets = [];
  int _offset = 0;
  bool _everythingLoaded = false;

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
      _everythingLoaded = false;
    });
    Hardverapro.search(_searchQuery.text, _filter ?? Filter(), 0)
        .then((result) {
      if (!context.mounted) return;
      setState(() {
        _posts = result.posts;
        _offsets = result.offsets;
      });
    }).whenComplete(
      () => setState(() {
        _state = LoadingState.ready;
      }),
    );
  }

  void _loadMore() {
    setState(() {
      _state = LoadingState.loadingAdditional;
    });
    Hardverapro.search(
      _searchQuery.text,
      _filter ?? Filter(),
      _offset,
    ).then((result) {
      if (!context.mounted) return;
      setState(() {
        _posts.addAll(result.posts);
        _offsets = result.offsets;
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
    Hardverapro.homePosts().then((result) {
      setState(() {
        _posts = result.posts;
        _offsets = result.offsets;
        _offset = _offsets.first;
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
            return InfiniteScrollList(
              padding: const EdgeInsets.all(8.0),
              everythingLoaded: _everythingLoaded,
              onLoadingStart: (_) {
                if (_offsets.indexOf(_offset) + 1 >= _offsets.length) {
                  setState(() {
                    _everythingLoaded = true;
                  });
                } else {
                  _offset = _offsets[_offsets.indexOf(_offset) + 1];
                  _loadMore();
                }
              },
              children: [..._posts.map((post) => SearchResult(post: post))],
            );
          }
        },
      ),
    );
  }
}
