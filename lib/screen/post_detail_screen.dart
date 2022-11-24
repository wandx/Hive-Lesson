import 'package:flutter/material.dart';
import 'package:playground/model/post.dart';
import 'package:playground/screen/post_add_screen.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post _post;

  @override
  void initState() {
    _post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_post.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostAddScreen(
                    post: _post,
                  ),
                ),
              ).then((result) {
                if (result != null && result is Post) {
                  setState(() {
                    _post = result;
                  });
                }
              });
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _post.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _post.author,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(_post.content),
          ],
        ),
      ),
    );
  }
}
