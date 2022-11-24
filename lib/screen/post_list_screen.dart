import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:playground/model/constant.dart' as c;
import 'package:playground/model/post.dart';
import 'package:playground/screen/post_add_screen.dart';
import 'package:playground/screen/post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    Hive.openBox<Post>(c.postBox).then((box) {
      _posts.addAll(box.values.map((e) {
        final newPost = Post(
          e.title,
          e.author,
          e.content,
          id: e.key,
        );
        return newPost;
      }).toList());
    });
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => const PostAddScreen(),
            ),
          )
              .then((value) async {
            _refreshData();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(builder: (context) {
        if (_posts.isEmpty) {
          return Center(child: Text('No Posts'));
        }
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.separated(
            itemBuilder: (context, i) => ListTile(
              title: Text('${_posts[i].title} (${_posts[i].id})'),
              subtitle: Text(_posts[i].author),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(
                    post: _posts[i],
                  ),
                ),
              ).then((value) {
                _refreshData();
              }),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await showDialog<bool?>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Delete ${_posts[i].title} ?'),
                      content: Text(
                        'Are you sure want to delete ${_posts[i].title} ?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  ).then((result) async {
                    if (result != null && result) {
                      _delete(_posts[i].id);
                    }
                  });
                },
              ),
            ),
            separatorBuilder: (context, i) => Divider(),
            itemCount: _posts.length,
          ),
        );
      }),
    );
  }

  Future<void> _delete(int id) async {
    late Box<Post> box;
    if (Hive.isBoxOpen(c.postBox)) {
      box = Hive.box(c.postBox);
    } else {
      box = await Hive.openBox(c.postBox);
    }
    await box.delete(id);
    _refreshData();
  }

  Future<void> _refreshData() async {
    late Box<Post> box;
    if (Hive.isBoxOpen(c.postBox)) {
      box = Hive.box(c.postBox);
    } else {
      box = await Hive.openBox(c.postBox);
    }
    _posts
      ..clear()
      ..addAll(box.values.map((e) {
        final newPost = Post(
          e.title,
          e.author,
          e.content,
          id: e.key,
        );
        return newPost;
      }).toList());
    setState(() {});
  }
}
