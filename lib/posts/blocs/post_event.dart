import 'dart:io';

import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class PostLoad extends PostEvent {
  final String gender;
  final String categoryId;
  const PostLoad(this.categoryId, this.gender);

  @override
  @override
  List<Object> get props => [];
}

class AllUserLoad extends PostEvent {
  
  const AllUserLoad();

  @override
  @override
  List<Object> get props => [];
}




class PostCreate extends PostEvent {
  final List<File> image;
  final PostElement post;
  final String categoryId;

  const PostCreate(this.post, this.image, this.categoryId);
  @override
  List<Object> get props => [post];

  @override
  String toString() => 'post created {post: $post} ';
}

class PostUpdate extends PostEvent {
  final PostElement post;
  final List<File> image;
  final String categoryId;

  const PostUpdate(this.post, this.image, this.categoryId);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'Post Updated {post: $post}';
}

class PostDelete extends PostEvent {
  final String post;
  final String categoryId;

  const PostDelete(this.post, this.categoryId);

  @override
  List<Object> get props => [post];

  @override
  toString() => 'post Deleted {post: $post}';
}


class ProfileUpdate extends PostEvent {
  final PostElement post;
  final String categoryID;
  const ProfileUpdate(this.post, this.categoryID);
  @override
  List<Object> get props => [post];

  @override
  String toString() => 'Post Updated {post: $post}';
}
