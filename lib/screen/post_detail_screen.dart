import 'package:flutter/material.dart';
import 'package:playground/model/post.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              post.author,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}
