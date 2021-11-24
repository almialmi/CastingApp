import 'dart:io';
import 'package:appp/lib.dart';

class AdvertRepo {
  

  AdvertProvider advertProvider;

  AdvertRepo() : assert(AdvertProvider != null) {
    AdvertProvider.getInstance().then((value) {
      this.advertProvider = value;
    });
  }

  Future<String> createadvert(AdvertElement advert) async {
    return await advertProvider.creatAdvert(advert);
  }

  Future<Advert> getadverts(String status) async {
    return await advertProvider.getadverts(status);
  }

  

  Future<String> deleteadvert(String id) async {
    return await advertProvider.deleteAdvert(id);
  }

  Future<String> updateAdvert(AdvertElement advert) async {
    return await advertProvider.updateAdverts(advert);
  }

  
}
