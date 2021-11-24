import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class AdvertState extends Equatable {
  const AdvertState();

  @override
  List<Object> get props => [];
}

class AdvertLoading extends AdvertState {}

class AdvertLoadSuccess extends AdvertState {
  final Advert advert;

  AdvertLoadSuccess([this.advert]);

  @override
  List<Object> get props => [advert];
}



class AdvertOperationFailure extends AdvertState {}


  

