import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import 'news_detail_page.dart';

class TopNews extends StatefulWidget {
  final String searchQuery;

  const TopNews({
    super.key,
    required this.searchQuery,
  });

  @override
  State<TopNews> createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
  final String apiKey = "pub_75271f2ba106b01d1fbab47e9366b56e432d5";
  late String topApi;

  List<Map<String, dynamic>> topNewsData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    topApi = "https://newsdata.io/api/1/news?apikey=$apiKey&language=en";
    fetchTopNews();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    final filteredNews = topNewsData.where((news){
      return news['title'].toLowerCase().contains(widget.searchQuery.toLowerCase());
    }).toList();

    return SizedBox(
      height: height * 0.8,
      child: _isLoading
          ? const Align(
        alignment: Alignment.topCenter,
        child: CircularProgressIndicator(),
         )
          : ListView.builder(
        itemCount: filteredNews.length,
        itemBuilder: (context, index) {
          final news = filteredNews[index];
          return Center(
            child: Card(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewsDetailPage(news)),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: news['imageUrl'].startsWith('http')
                                ? NetworkImage(news['imageUrl'])
                                : const AssetImage('assets/images/default.jpg') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        news['title'],
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'MW',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchTopNews() async {
    try {
      final response = await http.get(Uri.parse(topApi));

      if (response.statusCode == 200) {
        final unescape = HtmlUnescape();
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data['results'] != null && data['results'].isNotEmpty) {
          final List<Map<String, dynamic>> fetchedNews = [];

          for (int i = 0; i < 10; i++) {
            final article = data['results'][i];

            final imageUrl = article['image_url'] ?? 'assets/images/default.jpg';
            final title = unescape.convert(article['title'] ?? "News");
            final description = unescape.convert(article['description'] ?? "No Description");
            final date = (article['pubDate'] ?? "No Date").split(" ")[0];
            final publisher = article['source_id'] ?? "No Publisher";

            fetchedNews.add({
              'imageUrl': imageUrl,
              'title': title,
              'description': description,
              'date' : date,
              'publisher' : publisher,
            });
          }

          setState(() {
            topNewsData = fetchedNews;
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to fetch top news");
      }
    } catch (e) {
      setState(() {});
    }
  }
}
