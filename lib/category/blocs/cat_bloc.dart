import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CatBloc extends HydratedBloc<CatEvent, CatState> {
  final CatRepo catrepository;

  CatState get initialState {
    return super.state ?? CategoryLoad();
  }

  CatBloc({@required this.catrepository})
      : assert(catrepository != null),
        super(CategoryLoading());

  @override
  Stream<CatState> mapEventToState(CatEvent event) async* {
    if (event is CategroyCreate) {
      try {
        final message =
            await catrepository.createCategory(event.cat, event.image);
        final cats = await catrepository.getCategory();
        if (message == "Category create successfully!!") {
          // yield Categorycreated();
          yield CategoryLoadSuccess(cats);
        } else {
          yield Categoryfailed();
        }
      } catch (_) {
        yield CategoryOperationFailure();
      }
    }

    if (event is CategoryLoad) {
      yield CategoryLoading();
      try {
        final cinemas = await catrepository.getCategory();
        yield CategoryLoadSuccess(cinemas);
      } catch (e) {
        print(e);
        yield CategoryOperationFailure();
      }
    }

    if (event is CategoryUpdate) {
      try {
        await catrepository.updateCategory(event.category);
        final category = await catrepository.getCategory();
        yield CategoryLoadSuccess(category);
      } catch (e) {
        yield CategoryOperationFailure();
      }
    }

    if (event is CategoryImageUpdate) {
      try {
        await catrepository.updateCategoryImage(event.category, event.image);
        final category = await catrepository.getCategory();
        yield CategoryLoadSuccess(category);
      } catch (e) {
        yield CategoryOperationFailure();
      }
    }

    if (event is CategoryDelete) {
      try {
        var message = await catrepository.deleteCategory(event.category);
        print("category bloc deletion mesage $message");
        if (message == "Category deleted successfully!") {
          //yield Categoryfailed();
          final category = await catrepository.getCategory();
          yield CategoryLoadSuccess(category);
        
        }
      } catch (e) {
        print(e);
        yield CategoryOperationFailure();
      }
    }
  }

  @override
  CatState fromJson(Map<String, dynamic> json) {
    try {
      final category = Category.listFromJson(json != null
          ? ((json["categories"] as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList())
          : []);
      final value = CategoryLoadSuccess(category);
      return value;
    } catch (e, a) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(CatState state) {
    try {
      if (state is CategoryLoadSuccess) {
        final val = Category.categoriesToJson(state.cats);
        return val;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

 
}
