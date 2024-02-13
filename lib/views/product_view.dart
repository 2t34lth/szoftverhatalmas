import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hardverapro_a_kezedben/hardverapro.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  HardveraproProduct? _product;

  @override
  void initState() {
    super.initState();

    Hardverapro.getPost(widget.url).then((product) => {
          setState(() {
            _product = product;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product details",
          overflow: TextOverflow.fade,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.url));
              },
              icon: const Icon(Icons.share),
            ),
          )
        ],
      ),
      body: _product == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    child: CarouselSlider(
                      items: _product!.images
                          .map((img) => FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                child: Image.network("https:$img"),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _product!.price ?? "unknown price",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32),
                            ),
                            Visibility(
                              visible: _product?.freezed ?? false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.ac_unit,
                                    size: 18,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Freezed",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  _product?.author.avatarUrl ??
                                      "https://i.pravatar.cc/300",
                                )),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_product?.author.username ??
                                        "unknown user"),
                                    Text(
                                      _product?.author.rating ??
                                          "unknown rating",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: HtmlWidget(
                              _product!.description ?? "<i>no description</i>",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
