import 'package:appp/lib.dart';
import 'package:appp/user/model/verify_model.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoadSuccess extends UserState {
  final Userr user;

  UserLoadSuccess([this.user ]);

  @override
  List<Object> get props => [user];
}

class UserOperationFailure extends UserState {}

class ShowVerifiessuccess extends UserState {
  final Verify message;
 

  ShowVerifiessuccess(this.message);
    
}

