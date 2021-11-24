import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class MaleState extends Equatable {
  const MaleState();

  @override
  List<Object> get props => [];
}

class MaleLoading extends MaleState {}

class MaleLoadSuccess extends MaleState {
  final Post posts;
  final String categoryId;

  MaleLoadSuccess({this.posts, this.categoryId});

  @override
  List<Object> get props => [posts];
}

class MaleOperationFailure extends MaleState {}
