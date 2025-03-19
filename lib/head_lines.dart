import 'package:e_news_app/news_detail_page.dart';
import 'package:flutter/material.dart';

class HeadLines extends StatefulWidget{

  final String publisher;
  final String date;
  final String imageUrl;
  final String title;
  final String description;

  const HeadLines({
    super.key,
    required this.publisher,
    required this.date,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  State<HeadLines> createState() => _HeadLinesState();
}

class _HeadLinesState extends State<HeadLines> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: GestureDetector(
        onTap: (){
          Map<String, dynamic> news = {
            'publisher': widget.publisher,
            'date': widget.date,
            'imageUrl': widget.imageUrl,
            'title': widget.title,
            'description': widget.description,
          };

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsDetailPage(news)),
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.imageUrl.isNotEmpty ?
                      Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/sports.jpg', fit: BoxFit.cover);
                        },
                      )
                      : Image.asset('assets/images/sports.jpg', fit: BoxFit.cover),
                )
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                      child: Card(
                        elevation: 20,
                        color: Color(0xFFfefae0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'MW',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        widget.publisher,
                                        style: TextStyle(
                                          fontFamily: 'MW',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                  ),

                                  Text(
                                    widget.date,
                                    style: TextStyle(
                                      fontFamily: 'MW',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}