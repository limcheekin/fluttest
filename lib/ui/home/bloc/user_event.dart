import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const <dynamic>[]]) : super(props);
}

// The only event in this app is for getting the full name of user
class GetUserFullName extends UserEvent {
  final String username;

  // Equatable allows for a simple value equality in Dart.
  // All you need to do is to pass the class fields to the super constructor.
  // this._username is not supported
  GetUserFullName({@required this.username}) : super([username]);
}