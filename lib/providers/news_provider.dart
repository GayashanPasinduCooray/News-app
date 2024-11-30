import 'dart:math';
import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/api_service.dart';
import '../db/db_helper.dart'; // Import the database helper

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _favoriteArticles = [];
  bool _isLoading = false;

  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get favoriteArticles => _favoriteArticles;
  bool get isLoading => _isLoading;

  final DBHelper _dbHelper = DBHelper(); // Create an instance of DBHelper

  // Fetch articles from the API
  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners about loading state

    try {
      final response = await ApiService().fetchTopHeadlines();
      _articles = response.map((json) => NewsArticle.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching articles: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after data is loaded
    }
  }

  // Sort articles by the published date for "Latest News"
  void sortArticlesByDate() {
    _articles.sort((a, b) {
      if (a.publishedAt != null && b.publishedAt != null) {
        return b.publishedAt!.compareTo(a.publishedAt!); // Descending order
      }
      // Handle cases where publishedAt is null
      if (a.publishedAt == null && b.publishedAt != null) return 1;
      if (a.publishedAt != null && b.publishedAt == null) return -1;
      return 0;
    });
    notifyListeners(); // Notify listeners to refresh the UI
  }

  // Sort articles alphabetically A-Z or Z-A
  void sortArticlesAlphabetically(bool ascending) {
    _articles.sort((a, b) {
      int result = a.title.compareTo(b.title);
      return ascending ? result : -result;
    });
    notifyListeners(); // Notify listeners to refresh the UI
  }

  // Load favorites from the database
  Future<void> loadFavorites() async {
    _favoriteArticles = await _dbHelper.fetchFavorites();
    notifyListeners(); // Notify listeners to refresh the UI
  }

  // Add or remove an article from favorites
  Future<void> toggleFavorite(NewsArticle article) async {
    if (_favoriteArticles.any((fav) => fav.title == article.title)) {
      // Remove from favorites
      _favoriteArticles.removeWhere((fav) => fav.title == article.title);
      await _dbHelper.deleteFavorite(article.title);
    } else {
      // Add to favorites
      _favoriteArticles.add(article);
      await _dbHelper.insertFavorite(article);
    }
    notifyListeners(); // Refresh the UI
  }
}
