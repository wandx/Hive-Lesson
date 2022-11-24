import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:playground/model/constant.dart' as constant;
import 'package:playground/model/post.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({
    Key? key,
    this.post,
  }) : super(key: key);

  final Post? post;

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final _title = TextEditingController();
  final _author = TextEditingController(text: 'Wandy');
  final _content = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      _title.text = widget.post!.title;
      _author.text = widget.post!.author;
      _content.text = widget.post!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Type your title here',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Title required';
                    }
                    return null;
                  },
                  onSaved: (v) {},
                ),
                TextFormField(
                  enabled: false,
                  controller: _author,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    hintText: 'Type your title here',
                  ),
                ),
                TextFormField(
                  controller: _content,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    hintText: 'Type your content here',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Title required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 40),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      late Box<Post> openBox;

                      final isOpen = Hive.isBoxOpen(constant.postBox);

                      if (isOpen) {
                        openBox = Hive.box(constant.postBox);
                      } else {
                        openBox = await Hive.openBox(constant.postBox);
                      }

                      final post = Post(
                        _title.text,
                        _author.text,
                        _content.text,
                      );

                      if (widget.post != null) {
                        /// Edit mode
                        openBox.put(widget.post!.id, post).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post Updated'),
                            ),
                          );
                          Navigator.pop(
                            context,
                            Post(
                              post.title,
                              post.author,
                              post.content,
                              id: widget.post!.id,
                            ),
                          );
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        });
                      } else {
                        /// Add mode
                        openBox.add(post).then(
                          (id) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Post created with id $id'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        });
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
