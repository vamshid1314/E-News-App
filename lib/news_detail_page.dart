import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget{
  final Map<String, dynamic> news;

  const NewsDetailPage(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("News"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:10),
              Text(
                news['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "MW",
                  fontSize: 20,
                ),
              ),
          
              SizedBox(height:20),
          
              SizedBox(
                width: double.infinity,
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:news['imageUrl'] != null && news['imageUrl']!.isNotEmpty
                   ? Image.network(
                      news['imageUrl'],
                     fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace){
                        return Image.asset("assets/images/default.jpg");
                     },
                   )
                      :  Image.asset("assets/images/default.jpg"),
                ),
              ),
          
              SizedBox(height:20),
          
              Row(
                children: [
                  Expanded(
                    child: Text(
                      news['date'],
                      style: TextStyle(
                        fontFamily: "MW",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 190),
                  Expanded(
                      child: Text(
                        news['publisher'] ?? "Vamshi",
                        style: TextStyle(
                          fontFamily: "MW",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ],
              ),
          
              SizedBox(height:20),
          
          
              Text(
                news['description'],
                style: TextStyle(
                  fontFamily: "MW",
                  fontSize: 25,
                ),
              ),

              SizedBox(height:30),
            ],
          ),
        ),
      ),
    );
  }

}