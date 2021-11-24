import 'dart:io';

import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class AdvertEvent extends Equatable {
  const AdvertEvent();
}

class AdvertLoad extends AdvertEvent {
  final String status;

  const AdvertLoad(this.status);

  @override
  @override
  List<Object> get props => [];
}

class AdvertCreate extends AdvertEvent {
  final AdvertElement advert;

  const AdvertCreate(this.advert);
  @override
  List<Object> get props => [advert];

  @override
  String toString() => 'advert created {post: $advert} ';
}

class AdvertUpdate extends AdvertEvent {
  final AdvertElement advert;
  const AdvertUpdate(this.advert);
  @override
  List<Object> get props => [advert];

  @override
  String toString() => 'advert Updated {post: $advert}';
}

class AdvertDelete extends AdvertEvent {
  final String advert;

  const AdvertDelete(this.advert);

  @override
  List<Object> get props => [advert];

  @override
  toString() => 'advert Deleted {post: $advert}';
}
