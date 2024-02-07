import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  Future<void> _search() async {
    final posts = await Hardverapro.search(_searchQuery.text);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(
            child: ListView(
              children: _posts.isEmpty
                  ? [const Text("varunk...")]
                  : _posts.map((el) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
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
                                      Text(
                                        "${el.author.username} (${el.author.rating})",
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
            ),
          )
        ]),
      ),
    );
  }
}
