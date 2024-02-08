import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/product_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
        title: 'szoftver hatalmas',
        theme: ThemeData(
          colorScheme: lightDynamic,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic,
          useMaterial3: true,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchQuery = TextEditingController();
  List<HardveraproPost> _posts = [];
  bool _searchOpen = false;

  @override
  void initState() {
    super.initState();
    Hardverapro.homePosts().then((posts) {
      setState(() {
        _posts = posts;
      });
    });
  }

  Future<void> _search() async {
    setState(() {
      _posts = [];
    });
    final posts = await Hardverapro.search(_searchQuery.text);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        flexibleSpace: _searchOpen
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBar(
                    hintText: "Search",
                    elevation: const MaterialStatePropertyAll(1),
                    trailing: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _search,
                      )
                    ],
                    controller: _searchQuery,
                  ),
                ),
              )
            : null,
        title: !_searchOpen ? const Text("SzoftverHatalamas") : null,
        actions: !_searchOpen
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchOpen = true;
                      });
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),
                )
              ]
            : null,
      ),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: ListView(
                  children: _posts.map((el) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
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
            ),
    );
  }
}
