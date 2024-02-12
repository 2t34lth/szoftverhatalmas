import 'package:flutter/material.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';
import 'package:hardverapro_a_kezedben/views/product_view.dart';

class SearchResult extends StatelessWidget {
  final HardveraproPost post;
  const SearchResult({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ProductView(
                url: post.url!,
                title: post.title ?? "unknown title",
              ),
            ),
          );
        },
        child: Column(
          children: [
            Image.network(
              post.imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    post.title ?? "unknown title",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                      visible: post.freezed,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.ac_unit,
                                size: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Freezed",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.price ?? "unknown price",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            post.author.username ?? "unknown author",
                          ),
                          const SizedBox(width: 5),
                          Text(
                            post.author.rating ?? "(unknown rating)",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
  }
}
