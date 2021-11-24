import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class CatState extends Equatable {
  const CatState();

  @override
  List<Object> get props => [];
}

class CategoryIntial extends CatState {}

class CategoryLoading extends CatState {}

class Categoryfailed extends CatState {
  
}

class CategoryLoadSuccess extends CatState {
  final List<Category> cats;

  CategoryLoadSuccess([this.cats = const []]);

  @override
  List<Object> get props => [cats];
}

class CategoryOperationFailure extends CatState {}
