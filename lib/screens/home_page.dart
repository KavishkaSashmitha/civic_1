import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart'
    as slider; // Import carousel slider package

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civic Alert',
      theme: ThemeData.dark(), // Dark theme to match the image
      home: NewsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: 'CIVIC ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: 'ALERT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red, // Red color for "ALERT"
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
              IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50), // Adjust height here
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.red, // Red background for selected tab
                  borderRadius: BorderRadius.circular(50), // Rounded corners
                ),
                indicatorPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5), // Reduced padding for smaller indicator
                unselectedLabelColor:
                    Colors.white, // White text for unselected tabs
                labelColor: Colors.white, // White text for selected tab
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.symmetric(
                    vertical: 2), // Reduce vertical padding
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Breaking news'),
                  Tab(text: 'Latest'),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              NewsTab(), // "All" Tab
              NewsTab(), // "Breaking news" Tab
              NewsTab(), // "Latest" Tab
            ],
          ),
        ));
  }
}

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=017fa2ca29d8471981d6813d3c2d9937';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          articles = data['articles'];
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder image list (use actual image URLs if available from API)
    List<String> imgList = articles
        .where((article) => article['urlToImage'] != null)
        .map((article) => article['urlToImage'] as String)
        .toList();

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // Image Slider
        if (imgList.isNotEmpty)
          slider.CarouselSlider(
            options: slider.CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              viewportFraction: 1.0,
            ),
            items: imgList
                .map((item) => Container(
                      child: Center(
                        child:
                            Image.network(item, fit: BoxFit.cover, width: 1000),
                      ),
                    ))
                .toList(),
          ),
        SizedBox(height: 14),
        // News Cards
        ...articles.map((article) {
          return Column(
            children: [
              NewsCard(
                category: article['source']['name'] ?? "Unknown",
                timeAgo: article['publishedAt'] ?? "",
                headline: article['title'] ?? "No title available",
                imageUrl: article['urlToImage'] ??
                    'https://via.placeholder.com/400x200',
              ),
              SizedBox(height: 14),
            ],
          );
        }).toList(),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final String category;
  final String timeAgo;
  final String headline;
  final String imageUrl;

  const NewsCard(
      {super.key,
      required this.category,
      required this.timeAgo,
      required this.headline,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Ensure all cards have the same height
      child: Card(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image on the left
              SizedBox(
                width: 100, // Set the width of the image
                height: 100,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16), // Space between image and text
              // Text on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      headline,
                      maxLines: 2, // Limit headline to 2 lines
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
