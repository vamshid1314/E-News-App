import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_news_app/secure_storage.dart';
import 'package:e_news_app/head_lines.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'login_screen.dart';
import 'news_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "pub_750741ee047c8ffce9991274facb30157275b";
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

  Timer? _debounce;

  bool _isLoading = true;
  bool _isTopLoading = true;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<Map<String, dynamic>> filteredNews = [];

  String nextPage = "";
  int page = 1;

  ScrollController pagination = ScrollController();

  @override
  void initState() {
    super.initState();
    sportsUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&q=cricket";
    moviesUrl =
        "https://newsdata.io/api/1/news?apikey=$apiKey&q=telugu%20movies&country=in&language=en";
    eduUrl =
        "https://newsdata.io/api/1/news?apikey=$apiKey&country=in&language=en&category=education,technology";
    politicsUrl =
        "https://newsdata.io/api/1/news?apikey=$apiKey&q=india&country=in&language=en&category=politics";
    tourismUrl =
        "https://newsdata.io/api/1/news?apikey=$apiKey&country=in&language=en&category=tourism";
    lifestyleUrl =
        "https://newsdata.io/api/1/news?apikey=$apiKey&country=in&language=en&category=lifestyle";
    fetchNews();

    _searchController.addListener(_onSearchChanged);

    fetchTopNews(page);
    pagination.addListener(() {
      if (pagination.position.pixels >= pagination.position.maxScrollExtent) {
        page++;
        fetchTopNews(page);
      }
    });
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
              onPressed: () {
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
              : CustomScrollView(
                  controller: pagination,
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
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
                              thickness: 1,
                              indent: 20,
                              endIndent: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: 300,
                      floating: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: SizedBox(
                          height: 300,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var category in newsData.entries)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 8),
                                    child: SizedBox(
                                      width: width * 0.9,
                                      height: 300,
                                      child: HeadLines(
                                        publisher:
                                            category.value['publisher'] ?? "",
                                        date: category.value['date'] ?? "",
                                        imageUrl:
                                            category.value['imageUrl'] ?? "",
                                        title: category.value['title'] ?? "",
                                        description:
                                            category.value['description'] ?? "",
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: 80,
                      toolbarHeight: 80,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
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
                              thickness: 1,
                              indent: 20,
                              endIndent: 10,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    if(_isTopLoading)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    if(!_isTopLoading && filteredNews.isEmpty)
                      SliverToBoxAdapter(
                        child: Center(child: Text("No data found")),
                      ),
                    if(!_isTopLoading && filteredNews.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: filteredNews.length + 1, (context, index) {
                          if (index < filteredNews.length) {
                            final news = filteredNews[index];
                            return Center(
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailPage(news),
                                      ),
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
                                                  : const AssetImage(
                                                  'assets/images/default.jpg')
                                              as ImageProvider,
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
                          }else if(nextPage.isNotEmpty){
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                      ),
                    ),
                  ],
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
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
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
      Map<String, Map<String, dynamic>> tempData = {};

      for (int i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          final data = jsonDecode(utf8.decode(responses[i].bodyBytes));

          if (data['results'] != null && data['results'].isNotEmpty) {
            final firstArticle = data['results'][0];
            tempData[urls.keys.elementAt(i)] = {
              'publisher': unescape
                  .convert(firstArticle['source_name'] ?? "No Publisher"),
              'date': (firstArticle['pubDate'] ?? "No Date").split(' ')[0],
              'imageUrl': (firstArticle['image_url'] != null &&
                      firstArticle['image_url'].isNotEmpty)
                  ? firstArticle['image_url']
                  : 'assets/images/sports.jpg',
              'title': unescape.convert(firstArticle['title'] ?? "News"),
              'description': unescape
                  .convert(firstArticle['description'] ?? "No description"),
            };
          } else {
            throw Exception("No articles found for ${urls.keys.elementAt(i)}");
          }
        } else {
          throw Exception(
              "Failed to fetch news for ${urls.keys.elementAt(i)} with status: ${responses[i].statusCode}");
        }
      }
      setState(() {
        newsData = tempData;
        _isLoading = false;
      });
    } catch (e) {
      throw Exception("Error fetching news: $e");
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
        if (searchQuery.isEmpty) {
          // Reset to original top news list when the search is empty
          filteredNews.clear();
          fetchTopNews(1);
        } else {
          // Filter from original list instead of already filtered ones
          filteredNews = filteredNews.where((news) {
            final title = news['title'].toLowerCase();
            final description = news['description'].toLowerCase();
            return title.contains(searchQuery) || description.contains(searchQuery);
          }).toList();
        }
      });
    });
  }

  Future<void> fetchTopNews(int page) async {
    try {
      String apiUrl = "";
      if (page == 1) {
        apiUrl = "https://newsdata.io/api/1/news?apikey=$apiKey&language=en";
      } else {
        apiUrl =
        "https://newsdata.io/api/1/news?apikey=$apiKey&language=en&page=$nextPage";
      }
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final unescape = HtmlUnescape();
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data['results'] != null && data['results'].isNotEmpty) {
          final List<Map<String, dynamic>> fetchedNews = [];

          for (var article in data['results']) {
            final imageUrl =
                article['image_url'] ?? 'assets/images/default.jpg';
            final title = unescape.convert(article['title'] ?? "News");
            final description =
            unescape.convert(article['description'] ?? "No Description");
            final date = (article['pubDate'] ?? "No Date").split(" ")[0];
            final publisher = article['source_id'] ?? "No Publisher";
            nextPage = data['nextPage'];

            fetchedNews.add({
              'imageUrl': imageUrl,
              'title': title,
              'description': description,
              'date': date,
              'publisher': publisher,
            });
          }

          setState(() {
            filteredNews.addAll(fetchedNews);
            _isTopLoading = false;
          });
        }
      } else {
        throw Exception("Failed to fetch top news");
      }
    } catch (e) {
      setState(() {
        _isTopLoading = false;
      });
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

