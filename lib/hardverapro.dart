import "package:http/http.dart" as http;
import "package:html/parser.dart";

class Hardverapro {
  static Future<List<HardveraproPost>> search(String query) async {
    final resp = await http.get(
      Uri.parse(
          "https://hardverapro.hu/aprok/keres.php?stext=${Uri.encodeFull(query)}"),
    );

    final document = parse(resp.body);

    final posts = document.querySelectorAll(".media").map((el) {
      return HardveraproPost(
        title: el.querySelector("h1")?.text,
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
        author: HardveraproPostAuthor(
          username: el
              .querySelector(".uad-misc")
              ?.querySelector(".uad-light > a")
              ?.text,
          rating: el.querySelector(".uad-rating")?.text,
        ),
      );
    }).toList();

    for (var element in posts) {
      print(element.title);
    }

    return posts;
  }
}

class HardveraproPost {
  final String? title;
  final String? price;
  final String? location;
  final String? imageUrl;
  final HardveraproPostAuthor author;

  HardveraproPost({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.author,
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
