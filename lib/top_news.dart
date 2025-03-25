// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'package:http/http.dart' as http;
// import 'news_detail_page.dart';
//
// class TopNews extends StatefulWidget {
//   final String searchQuery; // Search query for filtering news
//
//   const TopNews({
//     super.key,
//     required this.searchQuery,
//   });
//
//   @override
//   State<TopNews> createState() => _TopNewsState();
// }
//
// class _TopNewsState extends State<TopNews> {
//   final String apiKey = "pub_75271f2ba106b01d1fbab47e9366b56e432d5";
//   bool _isLoading = true;
//
//
//   ScrollController pagination = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return CustomScrollView(
//       controller: pagination,
//       slivers: [
//         if (_isLoading)
//           const SliverToBoxAdapter(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         if (!_isLoading && filteredNews.isEmpty)
//           const SliverToBoxAdapter(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Text("No Data Found"),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//
//
//   // Filter news based on the search query
//   void _applyFilter() {
//     final query = widget.searchQuery.toLowerCase();
//     filteredNews = allNews.where((news) {
//       final title = news['title'].toLowerCase();
//       final description = news['description'].toLowerCase();
//       return title.contains(query) || description.contains(query);
//     }).toList();
//   }
//
//
// }
