import 'package:appp/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserState extends Cubit<Userr> {
  static UserState _instance;
  UserState({this.repo})
      : assert(repo != null),
        super(null) {
    if (_instance == null) {
      _instance == this;
    }
        }
    UserRepository repo;

    static UserState get instance {
    return _instance;
  }


    Future<Userr> getLoggedInUser() async {
    final user = await this.repo.getLoggedInUser();
    return user;
  }
  }

