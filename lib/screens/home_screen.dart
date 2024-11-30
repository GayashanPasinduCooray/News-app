import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../providers/news_provider.dart';
import '../screens/news_detail_screen.dart';
import '../screens/search_screen.dart';
import '../screens/category_screen.dart';
import '../widgets/news_tile.dart';
import '../screens/FavoritesScreen.dart';
import '../screens/Settings_Screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    // Handle sorting based on user's selection
    void _sortArticles(String sortOption) {
      switch (sortOption) {
        case 'A-Z':
          newsProvider.sortArticlesAlphabetically(true); // A-Z
          break;
        case 'Z-A':
          newsProvider.sortArticlesAlphabetically(false); // Z-A
          break;
        case 'Latest News':
          newsProvider.sortArticlesByDate(); // Latest news (no randomization)
          break;
        default:
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortArticles,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Latest News',
                child: Text('Latest News'),
              ),
              PopupMenuItem(
                value: 'A-Z',
                child: Text('A-Z'),
              ),
              PopupMenuItem(
                value: 'Z-A',
                child: Text('Z-A'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              _isGridView ? Icons.grid_view : Icons.view_list,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                "News App Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Categories"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Search News"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favorite News"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: newsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : newsProvider.articles.isEmpty
          ? Center(child: Text("No news articles available."))
          : _isGridView
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: newsProvider.articles.length,
        itemBuilder: (context, index) {
          final article = newsProvider.articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailScreen(article: article),
                ),
              );
            },
            child: NewsTile(article: article),
          );
        },
      )
          : ListView.builder(
        itemCount: newsProvider.articles.length,
        itemBuilder: (context, index) {
          final article = newsProvider.articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailScreen(article: article),
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
