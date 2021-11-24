import 'dart:io';
import 'package:appp/lib.dart';

class CatRepo {
  CategoryProvider catProvider;

  CatRepo() : assert(CategoryProvider != null) {
    CategoryProvider.getInstance().then((value) {
      this.catProvider = value;
      print("cat first${this.catProvider}");
    });
  }

  

  Future<String> createCategory(Category cat, File file) async {
    return await catProvider.createCategory(cat, file);
  }

  Future<List<Category>> getCategory() async {
    return await catProvider.getCategory();
  }

  Future<String> deleteCategory(String id) async {
    return await catProvider.deleteCategory(id);
  }

  Future<void> updateCategory(Category category) async {
    return await catProvider.updateCategory(category);
  }

  Future<void> updateCategoryImage(Category category, File file) async {
    return await catProvider.updateCategoryimage(category, file);
  }
}
