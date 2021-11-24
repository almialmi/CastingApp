import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  final UserRepository userrepository;

  UserBloc({@required this.userrepository})
      : assert(userrepository != null),
        super(UserLoading());
  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoad) {
      yield UserLoading();
      try {
        final users = await userrepository.fetchownprofile();
        print("this is user $users");

        yield UserLoadSuccess(users);
      } catch (e) {
        yield UserOperationFailure();
      }
    }

    if (event is UserUpdate) {
      try {
        await userrepository.updateUser(event.user);
        final user = await userrepository.fetchownprofile();
        yield UserLoadSuccess(user);
      } catch (e) {
        print(e);
        yield UserOperationFailure();
      }
    }

    if (event is ProfilePicUpdate) {
      try {
        await userrepository.updateProfilePic(event.image);
        final user = await userrepository.fetchownprofile();
        yield UserLoadSuccess(user);
      } catch (e) {
        print(e);
        yield UserOperationFailure();
      }
    }

    if (event is Verifyemail) {
      //yield EventLoading();
      try {
        final events = await userrepository.showverification(event.code);
        yield ShowVerifiessuccess(events);
        // final eventt = await eventrepository.getEvents("false");
        // yield EventLoadSuccess(eventt);

      } catch (e) {
        print(e);
        print("failed");
        yield UserOperationFailure();
      }
    }
  }

  @override
  UserState fromJson(Map<String, dynamic> json) {
    try {
      final user = Userr.fromJson(json);
      print("fucking user from json is $json");
      if (user == null) {
        return UserOperationFailure();
      }

      return UserLoadSuccess(user);
    } catch (e, a) {
      return UserOperationFailure();
    }
  }

  @override
  Map<String, dynamic> toJson(UserState state) {
    try {
      if (state is UserLoadSuccess) {
        if (state.user == null) {
          return null;
        }
        print("fucking to json is ${state.user.toJson()}");
        return state.user.toJson();
      }
    } catch (e, a) {
      print("catch of tojson $e");
      return null;
    }
    return null;
  }
}
