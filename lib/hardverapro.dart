import "package:http/http.dart" as http;
import "package:html/parser.dart";

class Hardverapro {
  static Future<List<HardveraproPost>> search(String query) async {
    final resp = await http.get(
      Uri.parse(
          "https://hardverapro.hu/aprok/keres.php?stext=${Uri.encodeFull(query)}"),
    );

    final document = parse(resp.body);

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
        author: HardveraproPostAuthor(
          username: el
              .querySelector(".uad-misc")
              ?.querySelector(".uad-light > a")
              ?.text,
          rating: el.querySelector(".uad-rating")?.text,
        ),
      );
    }).toList();
  }

  static Future<HardveraproProduct> getPost(String url) async {
    final resp = await http.get(Uri.parse(url));

    final document = parse(resp.body);
    final ad = document.querySelector(".uad");

    return HardveraproProduct(
      title: ad?.querySelector("h1")?.text.trim(),
      description: ad?.querySelector(".rtif-content")?.innerHtml.trim(),
      price: ad?.querySelector(".uad-details")?.querySelector("h2")?.text,
      images: ad
              ?.querySelectorAll(".carousel-item")
              .map<String?>((el) => el.querySelector("img")?.attributes["src"])
              .toList() ??
          [],
    );
  }
}

class HardveraproPost {
  final String? title;
  final String? price;
  final String? location;
  final String? imageUrl;
  final String? url;
  final HardveraproPostAuthor author;

  HardveraproPost({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.url,
    required this.author,
  });
}

class HardveraproProduct {
  final String? title;
  final String? description;
  final String? price;
  final List<String?> images;

  HardveraproProduct({
    required this.title,
    required this.description,
    required this.price,
    required this.images,
  });
}

class HardveraproPostAuthor {
  final String? username;
  final String? rating;

  HardveraproPostAuthor({
    required this.username,
    required this.rating,
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
