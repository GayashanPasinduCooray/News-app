class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final DateTime? publishedAt; // Optional DateTime for publication date
  final String? content;       // Optional content field
  final String? author;        // Optional author field

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    this.publishedAt,
    this.content,
    this.author, // Initialize the author
  });

  // Factory method to parse from JSON
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null, // Safely parse the date
      content: json['content'], // Content can be null
      author: json['author'],  // Fetch the author data from JSON
    );
  }
}

