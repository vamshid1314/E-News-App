import 'dart:async';
import 'dart:convert';
import 'package:e_news_app/top_news.dart';
import 'package:http/http.dart' as http;
import 'package:e_news_app/secure_storage.dart';
import 'package:e_news_app/head_lines.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "pub_75271f2ba106b01d1fbab47e9366b56e432d5";
  late String sportsUrl;
  late String moviesUrl;
  late String eduUrl;
  late String politicsUrl;
  late String tourismUrl;
  late String lifestyleUrl;

  String publisher = "";
  String date = "";
  String imageUrl = "";
  String title = "";
  String description = "";

  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    sportsUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&q=cricket";
    moviesUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&q=telugu%20movies&country=in&language=en";
    eduUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&country=in&language=en&category=education,technology";
    politicsUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&q=india&country=in&language=en&category=politics";
    tourismUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&country=in&language=en&category=tourism";
    lifestyleUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&country=in&language=en&category=lifestyle";
    fetchNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: SizedBox(
            width: 250,
            height: 35,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search..",
                hintStyle: const TextStyle(
                  fontFamily: "MW",
                  color: Colors.black,
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: (){
                  setState(() {
                    _isLoading = true;
                  });
                  fetchNews();
                },
                icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlueAccent,
                Colors.white,
                Colors.white70,
              ],
            ),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: const Text(
                        "Top HeadLines",
                        style: TextStyle(
                          fontFamily: 'MW',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                      indent: 20,
                      endIndent: 10,
                    ),
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var category in newsData.entries)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                              child: SizedBox(
                                width: width * 0.9,
                                height: 300,
                                child: HeadLines(
                                  publisher: category.value['publisher'] ?? "",
                                  date: category.value['date'] ?? "",
                                  imageUrl: category.value['imageUrl'] ?? "",
                                  title: category.value['title'] ?? "",
                                  description: category.value['description'] ?? "",
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          "Top news",
                           style: TextStyle(
                             fontFamily: "MW",
                             fontSize: 25,
                             fontWeight: FontWeight.bold,
                           ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                      indent: 20,
                      endIndent: 10,
                    ),
                    SizedBox(height:10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TopNews(searchQuery: _searchQuery),
                    ),
                  ],
                ),
              ),
        ),
        drawer: Drawer(
          width: 200,
          elevation: 10,
          surfaceTintColor: const Color(0xFF0077b6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF023e8a),
                    ),
                    onPressed: () {
                      SecureStorage().writeLoggedIn("isLogin", "false");
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Log-out",
                      style: TextStyle(
                        fontFamily: 'MW',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Map<String, dynamic>> newsData = {};

  Future<void> fetchNews() async {
    final urls = {
      'sports': sportsUrl,
      'movies': moviesUrl,
      'education': eduUrl,
      'politics': politicsUrl,
      'tourism': tourismUrl,
      'lifestyle': lifestyleUrl,
    };

    try {
      final responses = await Future.wait(
        urls.entries.map((entry) => http.get(Uri.parse(entry.value))),
      );

      final unescape = HtmlUnescape();

      for (int i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          final data = jsonDecode(utf8.decode(responses[i].bodyBytes));

          if (data['results'] != null && data['results'].isNotEmpty) {
            final firstArticle = data['results'][0];
            setState(() {
              newsData[urls.keys.elementAt(i)] = {
                'publisher': unescape.convert(firstArticle['source_name'] ?? "No Publisher"),
                'date': (firstArticle['pubDate'] ?? "No Date").split(' ')[0],
                'imageUrl': (firstArticle['image_url'] != null && firstArticle['image_url'].isNotEmpty)
                    ? firstArticle['image_url']
                    : 'assets/images/sports.jpg',
                'title': unescape.convert(firstArticle['title'] ?? "News"),
                'description' : unescape.convert(firstArticle['description'] ?? "No description"),
              };
            });
          } else {
            print("No articles found for ${urls.keys.elementAt(i)}");
          }
        } else {
          print("Failed to fetch news for ${urls.keys.elementAt(i)} with status: ${responses[i].statusCode}");
        }
      }
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (!_isLoading) {
      Timer(const Duration(seconds: 5), () {
        _startAutoScroll();
      });
    }
  }


  void _startAutoScroll() {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    const double padding = 36.0; // Horizontal padding between cards
    double offset = 0;

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
          offset = 0;
        } else {
          offset += cardWidth + padding;
          _scrollController.animateTo(
            offset,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }
}