import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class RequestBloc extends HydratedBloc<RequestEvent, RequestState> {
  RequestState get initialState {
    return super.state ?? RequestLoad();
  }

  final RequestRepo requestrepository;

  RequestBloc({@required this.requestrepository})
      : assert(requestrepository != null),
        super(RequestLoading());
  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    if (event is RequestCreate) {
      try {
        await requestrepository.createRequest(event.request);
        final request = await requestrepository.getAllRequest();

        yield RequestLoadSuccess(request);
      } catch (_) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestLoad) {
      yield RequestLoading();
      try {
        final request = await requestrepository.getAllRequest();
        yield RequestLoadSuccess(request);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is MyRequestLoad) {
      yield RequestLoading();
      try {
        final request = await requestrepository.getMyRequest();
        yield RequestLoadSuccess(request);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestUpdate) {
      try {
        await requestrepository.updateRequest(event.element);
        final request = await requestrepository.getAllRequest();
        yield RequestLoadSuccess(request);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestDelete) {
      try {
        await requestrepository.deleteReqyest(event.request);
        final requests = await requestrepository.getAllRequest();
        yield RequestLoadSuccess(requests);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
  }

  @override
  RequestState fromJson(Map<String, dynamic> json) {
    try {
      final request = Request.fromJson(json);
      if (request == null) {
        return RequestOperationFailure();
      }
      request.request.removeWhere((element) => element == null);
      if (request.request.length == 0) return RequestOperationFailure();
      return RequestLoadSuccess(request);
    } catch (e, a) {
      return RequestOperationFailure();
    }
  }

  @override
  Map<String, dynamic> toJson(RequestState state) {
    try {
      if (state is RequestLoadSuccess) {
        if (state.requests == null) {
          return null;
        }
        return state.requests.toJson();
      }
    } catch (e, a) {
      return null;
    }
    return null;
  }
}
