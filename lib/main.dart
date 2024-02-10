import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/views/account_view.dart';
import 'package:hardverapro_a_kezedben/views/messages_view.dart';
import 'package:hardverapro_a_kezedben/views/saved_view.dart';
import 'package:hardverapro_a_kezedben/views/search_view.dart';

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
  int _selectedPage = 0;

  final List<MaterialPage> _pages = [
    const MaterialPage(child: SearchView()),
    const MaterialPage(child: SavedView()),
    const MaterialPage(child: MessagesView()),
    const MaterialPage(child: AccountView()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: "Search"),
          NavigationDestination(icon: Icon(Icons.list), label: "Saved"),
          NavigationDestination(icon: Icon(Icons.message), label: "Messages"),
          NavigationDestination(icon: Icon(Icons.person), label: "Me"),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _selectedPage = value;
          });
        },
        selectedIndex: _selectedPage,
      ),
      body: Navigator(
        onPopPage: (a, b) {
          return true;
        },
        pages: [
          _pages.length > _selectedPage
              ? _pages[_selectedPage]
              : const MaterialPage(child: Placeholder())
        ],
      ),
    );
  }
}
