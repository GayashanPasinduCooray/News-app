import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_tile.dart';
import '../screens/news_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final favoriteArticles = newsProvider.favoriteArticles;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: favoriteArticles.isEmpty
          ? Center(child: Text("No favorites added yet."))
          : ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (context, index) {
          final article = favoriteArticles[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the NewsDetailScreen with the article data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(article: article),
                ),
              );
            },
            child: NewsTile(article: article),
          );
        },
      ),
    );
  }
}
