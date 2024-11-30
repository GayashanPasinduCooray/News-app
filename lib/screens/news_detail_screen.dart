import 'package:flutter/material.dart';
import '../models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title.isNotEmpty ? article.title : "News Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Image if available
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.urlToImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(); // Don't show anything on error
                    },
                  ),
                ),
              const SizedBox(height: 16.0),
              // Title
              Text(
                article.title.isNotEmpty ? article.title : "No Title Available",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 8.0),
              // Publication Date
              Text(
                article.publishedAt != null
                    ? "Published on ${article.publishedAt!.toLocal()}"
                    : "Publication Date Unavailable",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8.0),
              // Author Section
              if (article.author != null && article.author!.isNotEmpty)
                Text(
                  "Author: ${article.author}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (article.author == null || article.author!.isEmpty)
                const Text(
                  "Author: Unknown",
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 16.0),
              // Description
              Text(
                article.description.isNotEmpty
                    ? article.description
                    : "No description available.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              // Content
              Text(
                article.content != null && article.content!.isNotEmpty
                    ? article.content!
                    : "No content available.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
