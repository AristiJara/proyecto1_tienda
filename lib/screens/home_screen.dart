import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:proyecto1_tienda/models/article.dart';
import 'package:proyecto1_tienda/models/user.dart';
import 'package:proyecto1_tienda/screens/new_tem.dart';
import 'package:proyecto1_tienda/screens/auth.dart';
import 'package:proyecto1_tienda/screens/shopping_list.dart';
import 'package:proyecto1_tienda/widgets/article_list.dart';
import 'package:proyecto1_tienda/providers/user_provider.dart';
import 'package:proyecto1_tienda/widgets/drawer_option.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Article> _articles = [];
  final List<Map<String, dynamic>> _cartItems = [];

  void addArticle(Article article) {
    setState(() {
      _articles.add(article);
    }); 
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.18:6060/public/product'));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<Article> articles = responseData.map((data) => Article.fromJson(data)).toList();
        setState(() {
          _articles = articles;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? currentUser = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color(0xFF17203A),
        bottomOpacity: 0.0,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text(
                    'Artículos',
                    style: TextStyle(
                      color: Color(0xFF17203A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.shopping_cart,
                    color:  Color(0xFF17203A),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: ArticleList(
          articles: _articles,
          onDelete: (article) {
            setState(() {
              _articles.remove(article);
            });
          },
          onAddToCart: (article) {
            bool alreadyInCart = _cartItems.any((item) => item['name'] == article.name);
            if (!alreadyInCart) {
              setState(() {
                _cartItems.add({
                  'name': article.name,
                  'price': article.price,
                  'quantity': 1,
                });
              });
            }
          },
          userProvider: userProvider,
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF17203A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF17203A),
              ),
              child: currentUser != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bienvenido',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          currentUser.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Menú',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
            ),
            DrawerOption(
            icon: Icons.person_outline_sharp,
            title: currentUser != null ? 'User' : 'Mi cuenta',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            ),
            DrawerOption(
              icon: Icons.home_outlined,
              title: 'Inicio',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            DrawerOption(
              icon: Icons.shopping_cart_outlined,
              title: 'Lista',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingList(cartItems: _cartItems)),
                );
              },
            ),
            if (userProvider.isAdmin())
            DrawerOption(
              icon: Icons.list_alt_rounded,
              title: 'Inventario',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewItem(
                      addArticle: addArticle,
                    ),
                  ),
                );
              },
            ),
            DrawerOption(
              icon: Icons.exit_to_app,
              title: 'Cerrar Sesión',
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).clearUser();
              },
            ),
          ],
        ),
      ),
    );
  }
}