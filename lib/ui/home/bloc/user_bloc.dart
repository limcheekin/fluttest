import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fluttest/db/github_db.dart';
import 'package:fluttest/repository/user_repository.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => InitialUserState();
  final UserRepository _userRepository;

  UserBloc({@required userRepository}) : _userRepository = userRepository;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetUserFullName) {
      yield UserLoading();
      final User user = await _userRepository.refreshUser(event.username);
      yield UserLoaded(user);
    }
  }
}
