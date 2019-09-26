import 'package:equatable/equatable.dart';
import 'package:fluttest/db/github_db.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserState extends Equatable {
  UserState([List props = const <dynamic>[]]) : super(props);
}

class InitialUserState extends UserState {}

class UserLoading extends UserState {}

// Only the WeatherLoaded event needs to contain data
class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user) : super([user]);
}
