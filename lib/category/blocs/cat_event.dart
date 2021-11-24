import 'dart:io';
import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class CatEvent extends Equatable {
  const CatEvent();
}

class CategoryLoad extends CatEvent {
  const CategoryLoad();

  @override
  @override
  List<Object> get props => [];
}

class CategoryEmpty extends Equatable {
  const CategoryEmpty();
  @override
  @override
  List<Object> get props => [];
}

class CategroyCreate extends CatEvent {
  final File image;
  final Category cat;

  const CategroyCreate(this.cat, this.image);
  @override
  List<Object> get props => [cat];

  @override
  String toString() => 'post created {post: $cat} ';
}

class CategoryUpdate extends CatEvent {
  final Category category;

  const CategoryUpdate(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'Request Updated {post: $category}';
}

class CategoryImageUpdate extends CatEvent {
  final File image;
  final Category category;

  const CategoryImageUpdate(this.category, this.image);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'Request Updated {post: $category}';
}

class CategoryDelete extends CatEvent {
  //final RequestElement request;
  final String category;

  const CategoryDelete(this.category);

  @override
  List<Object> get props => [category];

  @override
  toString() => 'post Deleted {post: $category}';
}



