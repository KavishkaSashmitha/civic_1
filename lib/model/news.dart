class NewsArticle {
  final String headline;
  final String imageUrl;
  final String category;
  final String timeAgo;

  NewsArticle({
    required this.headline,
    required this.imageUrl,
    required this.category,
    required this.timeAgo,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      headline: json['title'] ?? 'No headline available',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/400x200',
      category: json['category'] ?? 'Unknown',
      timeAgo: json['publishedAt'] ?? 'Unknown time',
    );
  }
}
