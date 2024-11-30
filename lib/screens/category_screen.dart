import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/api_service.dart';
import '../widgets/news_tile.dart';
import '../screens/news_detail_screen.dart';  // Import the NewsDetailScreen

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService _apiService = ApiService();
  List<NewsArticle> _categoryNews = [];
  bool _isLoading = false;
  String _selectedCategory = '';

  void _fetchCategoryNews(String category) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = category; // Update selected category to show
    });

    try {
      final response = await _apiService.fetchTopHeadlinesByCategory(category);
      setState(() {
        _categoryNews = response.map((json) => NewsArticle.fromJson(json)).toList();
      });
    } catch (e) {
      print("Error: $e");
      // Optionally show an error message to the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Categories"),
      ),
      body: Column(
        children: [
          // Category selection buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              children: ["business", "sports", "technology", "entertainment"]
                  .map((category) => ElevatedButton(
                onPressed: () => _fetchCategoryNews(category),
                child: Text(category.toUpperCase()),
              ))
                  .toList(),
            ),
          ),
          // Display selected category
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _selectedCategory.isEmpty
                  ? "Select a category"
                  : "Showing news for: ${_selectedCategory.toUpperCase()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Display the news articles
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _categoryNews.isEmpty
                ? Center(child: Text("No news available for this category"))
                : ListView.builder(
              itemCount: _categoryNews.length,
              itemBuilder: (context, index) {
                final article = _categoryNews[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to NewsDetailScreen when a news item is tapped
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
          ),
        ],
      ),
    );
  }
}

