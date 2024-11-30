import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = '5b5c0ca039774973af32c409bcd2c6f9';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Fetch top headlines (for the home page)
  Future<List<dynamic>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Search news articles based on a query
  Future<List<dynamic>> searchNews(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to search news');
    }
  }

  // Fetch top headlines by category (for the CategoryScreen)
  Future<List<dynamic>> fetchTopHeadlinesByCategory(String category) async {
    final url = '$_baseUrl/top-headlines?category=$category&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];  // Assuming the response contains an 'articles' key.
    } else {
      throw Exception('Failed to load category news');
    }
  }
}

