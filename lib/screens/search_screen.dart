import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/api_service.dart';
import '../widgets/news_tile.dart';
import '../screens/news_detail_screen.dart';  // Import the NewsDetailScreen

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<NewsArticle> _searchResults = [];
  bool _isLoading = false;

  void _searchNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchNews(_searchController.text);
      setState(() {
        _searchResults = results.map((json) => NewsArticle.fromJson(json)).toList();
      });
    } catch (e) {
      print("Error: $e");
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
        title: Text("Search News"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchNews,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final article = _searchResults[index];
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
      ),
    );
  }
}
