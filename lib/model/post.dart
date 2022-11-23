import 'package:hive_flutter/hive_flutter.dart';
import 'package:playground/model/constant.dart';

part 'post.g.dart';

@HiveType(typeId: postTypeId)
class Post extends HiveObject {
  final int id;

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String content;

  Post(this.title,
      this.author,
      this.content, {
        this.id = 0,
      });
}
