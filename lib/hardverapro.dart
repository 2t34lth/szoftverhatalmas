import "package:html/dom.dart";
import "package:http/http.dart" as http;
import "package:html/parser.dart";

class Hardverapro {
  static List<HardveraproPost> parsePosts(Document document) {
    return document.querySelectorAll(".media").map((el) {
      return HardveraproPost(
        title: el.querySelector("h1")?.querySelector("a")?.text,
        price: el.querySelector(".uad-price")?.text,
        location: el.querySelector(".uad-light")?.querySelector("span") != null
            ? el
                .querySelector(".uad-light")
                ?.querySelector("span")
                ?.attributes["data-original-title"]
            : el.querySelector(".uad-light")?.text,
        imageUrl:
            "https:${el.querySelector(".uad-image")?.querySelector("img")?.attributes["src"]}"
                .replaceFirst(RegExp(r'\/100$'), "/400"),
        url: el.querySelector("h1")?.querySelector("a")?.attributes["href"],
        freezed: el
                .querySelector(".uad-title")
                ?.querySelector("span.fa-snowflake") !=
            null,
        author: HardveraproAuthor(
          username: el
              .querySelector(".uad-misc")
              ?.querySelector(".uad-light > a")
              ?.text,
          rating: el.querySelector(".uad-rating")?.text.trim(),
          avatarUrl: "",
        ),
      );
    }).toList();
  }

  static Future<List<HardveraproPost>> search(String query,
      {Category? category}) async {
    final resp = await http.get(
      Uri.parse(
          "https://hardverapro.hu/aprok/${category?.path}/keres.php?stext=${Uri.encodeFull(query)}"),
    );

    final Document document = parse(resp.body);
    return parsePosts(document);
  }

  static Future<HardveraproProduct> getPost(String url) async {
    final resp = await http.get(Uri.parse(url));

    final document = parse(resp.body);
    final ad = document.querySelector(".uad");

    return HardveraproProduct(
      title: ad?.querySelector("h1")?.text.trim(),
      description: ad?.querySelector(".rtif-content")?.innerHtml.trim(),
      price: ad?.querySelector(".uad-details")?.querySelector("h2")?.text,
      freezed: document.querySelector(".uad.iced") != null,
      author: HardveraproAuthor(
        username: document.querySelector(".uad")?.querySelector("b > a")?.text,
        rating: document
            .querySelector(".uad")
            ?.querySelectorAll("span.uad-rating")
            .last
            .text
            .trim(),
        avatarUrl:
            "https:${document.querySelector(".uad")?.querySelector(".uad-content-block.uad-time-location.align-items-center")?.querySelector("img")?.attributes["src"]}",
      ),
      images: ad
              ?.querySelectorAll(".carousel-item")
              .map<String?>((el) => el.querySelector("img")?.attributes["src"])
              .toList() ??
          [],
    );
  }

  static Future<List<HardveraproPost>> homePosts() async {
    final resp = await http.get(Uri.parse("https://hardverapro.hu/index.html"));

    final Document document = parse(resp.body);
    return parsePosts(document);
  }

  static Future<List<Category>> getCategories(String path) async {
    final resp = await http
        .get(Uri.parse("https://hardverapro.hu/aprok/$path/index.html"));
    final document = parse(resp.body);
    final pathRegex = RegExp(r'^\/aprok\/(.+)\/index.html$');

    if (document.querySelector(".uad-categories-item.active") != null) {
      return [];
    }

    return document
        .querySelector(".uad-categories")!
        .querySelectorAll("a.d-flex")
        .map((el) {
      return Category(
        name: el.text,
        path: pathRegex
            .firstMatch(el.attributes["href"]!
                .replaceAll(RegExp(r'\/keres\.php.*'), "/index.html"))!
            .group(1)!,
      );
    }).toList();
  }
}

class SearchResults {
  final List<Category>? categories;
  final List<HardveraproPost> results;

  SearchResults({required this.categories, required this.results});
}

class HardveraproPost {
  final String? title;
  final String? price;
  final String? location;
  final String? imageUrl;
  final String? url;
  final bool freezed;
  final HardveraproAuthor author;

  HardveraproPost({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.url,
    required this.freezed,
    required this.author,
  });
}

class HardveraproProduct {
  final String? title;
  final String? description;
  final String? price;
  final List<String?> images;
  final bool freezed;
  final HardveraproAuthor author;

  HardveraproProduct({
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.freezed,
    required this.author,
  });
}

class HardveraproAuthor {
  final String? username;
  final String? rating;
  final String? avatarUrl;

  HardveraproAuthor({
    required this.username,
    required this.rating,
    required this.avatarUrl,
  });
}

class Category {
  final String name;
  final String path;

  Category({
    required this.name,
    required this.path,
  });
}
