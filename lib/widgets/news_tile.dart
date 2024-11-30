import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../providers/news_provider.dart';

class NewsTile extends StatelessWidget {
  final NewsArticle article;

  const NewsTile({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: article.urlToImage == null || article.urlToImage!.isEmpty
            ? MainAxisAlignment.center // Center content when there's no image
            : MainAxisAlignment.start, // Start content normally when there's an image
        children: [
          // Image section
          if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
            Container(
              height: 120,
              width: double.infinity,
              child: Image.network(
                article.urlToImage!,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          // Title and description section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? "No Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2, // Limit the title to 2 lines
                  overflow: TextOverflow.ellipsis, // Truncate the title with ellipsis
                ),
                SizedBox(height: 4),
                Text(
                  article.description ?? "No Description Available",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Favorite button
          IconButton(
            icon: Icon(
              newsProvider.favoriteArticles.contains(article)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              newsProvider.toggleFavorite(article);
            },
          ),
        ],
      ),
    );
  }
}




