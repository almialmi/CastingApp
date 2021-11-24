import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {}

class PostLoadSuccess extends PostState {
  final Post posts;
  final String categoryID;

  PostLoadSuccess({this.posts, this.categoryID});

  @override
  List<Object> get props => [posts];
}

class PostOperationFailure extends PostState {}

class AllUserLoadSuccess extends PostState {
  final Post posts;
  

  AllUserLoadSuccess({this.posts});

  @override
  List<Object> get props => [posts];
}
