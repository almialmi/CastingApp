import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AdvertBloc extends HydratedBloc<AdvertEvent, AdvertState> {
  EventState get initialState {
    return super.state ?? AdvertLoad("Active");
  }

  final AdvertRepo advertrepository;

  AdvertBloc({@required this.advertrepository})
      : assert(advertrepository != null),
        super(AdvertLoading());
  @override
  Stream<AdvertState> mapEventToState(AdvertEvent event) async* {
    if (event is AdvertCreate) {
      try {
        var message = await advertrepository.createadvert(event.advert);
        if (message == "Advert created successfully!!") {
          final advert = await advertrepository.getadverts("Active");
          yield AdvertLoadSuccess(advert);
        }
        // else {
        //   yield Eventcreationfailed();
        // }
      } catch (_) {
        yield AdvertOperationFailure();
      }
    }
    if (event is AdvertLoad) {
      yield AdvertLoading();
      try {
        final events = await advertrepository.getadverts(event.status);

        yield AdvertLoadSuccess(events);
      } catch (e) {
        yield AdvertOperationFailure();
      }
    }

    if (event is AdvertUpdate) {
      try {
        await advertrepository.updateAdvert(event.advert);
        final eventt = await advertrepository.getadverts("Active");
        yield AdvertLoadSuccess(eventt);
      } catch (e) {
        print(e);
        yield AdvertOperationFailure();
      }
    }

    if (event is AdvertDelete) {
      try {
        var message = await advertrepository.deleteadvert(event.advert);
        if (message == "Advert deleted successfully!") {
          final eventt = await advertrepository.getadverts("Active");
          yield AdvertLoadSuccess(eventt);
        }
      } catch (e) {
        print(e);
        yield AdvertOperationFailure();
      }
    }
  }

  @override
  AdvertState fromJson(Map<String, dynamic> json) {
    try {
      final event = Advert.fromJson(json);
      if (event == null) {
        return AdvertOperationFailure();
      }
      event.adverts.removeWhere((element) => element == null);
      if (event.adverts.length == 0) return AdvertOperationFailure();
      return AdvertLoadSuccess(event);
    } catch (e, a) {
      return AdvertOperationFailure();
    }
  }

  @override
  Map<String, dynamic> toJson(AdvertState state) {
    try {
      if (state is AdvertLoadSuccess) {
        if (state.advert == null) {
          return null;
        }
        return state.advert.toJson();
      }
    } catch (e, a) {
      return null;
    }
    return null;
  }
}
