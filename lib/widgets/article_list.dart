import 'package:flutter/material.dart';
import 'package:proyecto1_tienda/models/article.dart';
import 'package:proyecto1_tienda/providers/user_provider.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;
  final Function(Article) onDelete;
  final Function(Article) onAddToCart;
  final UserProvider userProvider; 

  const ArticleList({
    Key? key,
    required this.articles,
    required this.onDelete,
    required this.onAddToCart,
     required this.userProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.1),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/${articles[index].imagenText}',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        articles[index].name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF17203A).withOpacity(0.2),
                            ),
                            child: Text(
                              '\$${articles[index].price}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF17203A),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () {
                                  onAddToCart(articles[index]);
                                },
                              ),
                              if (userProvider.isAdmin())
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  onDelete(articles[index]);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}