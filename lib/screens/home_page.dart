import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'
    as slider; // Import carousel slider package

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civic Alert',
      theme: ThemeData.dark(), // Dark theme to match the image
      home: NewsScreen(),
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

class NewsTab extends StatelessWidget {
  final List<String> imgList = [
    'https://via.placeholder.com/400x200', // Placeholder images
    'https://via.placeholder.com/400x200',
    'https://via.placeholder.com/400x200',
  ];

  NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // Image Slider
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
        // First News Card
        NewsCard(
          category: "Iran",
          timeAgo: "2 hours ago",
          headline:
              "Women's push for equality sparks nationwide Iranian protest",
          imageUrl: 'https://via.placeholder.com/400x200', // Placeholder image
        ),
        SizedBox(height: 14),
        NewsCard(
          category: "Iran",
          timeAgo: "20 minutes ago",
          headline:
              "People walked amid destruction as they evacuate a frontline area.",
          imageUrl: 'https://via.placeholder.com/400x200',
        ),
        SizedBox(height: 14),
        NewsCard(
          category: "Ukraine",
          timeAgo: "7 hours ago",
          headline:
              "Fleeing families arrive at the main train station in Ukraine's eastern...",
          imageUrl: 'https://via.placeholder.com/400x200',
        ),
        SizedBox(height: 14),
        NewsCard(
          category: "US",
          timeAgo: "6 hours ago",
          headline:
              "The UN General Assembly passes a resolution suspending Russia from...",
          imageUrl: 'https://via.placeholder.com/400x200',
        ),
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
