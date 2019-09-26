/*
 * Created by Alfonso Cejudo, Tuesday, July 9th 2019.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttest/db/github_db.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'bloc/bloc.dart';

class Home extends StatelessWidget {
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Fluttest',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocProvider(
          // This bloc can now be accessed from UsernameInput
          builder: (context) => userBloc,
          child: HomePageChild(),
        ));
  }
}

// Because we now don't hold a reference to the UserBloc directly,
// we have to get it through the BlocProvider. This is only possible from
// a widget which is a child of the BlocProvider in the widget tree.
class HomePageChild extends StatelessWidget {
  HomePageChild({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // BlocListener invokes the listener when new state is emitted.
      child: BlocListener(
        bloc: BlocProvider.of<UserBloc>(context),
        // Listener is the place for logging, showing Snackbars, navigating, etc.
        // It is guaranteed to run only once per state change.
        listener: (BuildContext context, UserState state) {
          if (state is UserLoaded) {
            print("Loaded: ${state.user.userId}");
          }
        },
        // BlocBuilder invokes the builder when new state is emitted.
        child: BlocBuilder(
          bloc: BlocProvider.of<UserBloc>(context),
          // The builder function has to be a "pure function".
          // That is, it only returns a Widget and doesn't do anything else.
          builder: (BuildContext context, UserState state) {
            // Changing the UI based on the current state
            if (state is InitialUserState) {
              return buildInitialInput();
            } else if (state is UserLoading) {
              return buildLoading();
            } else if (state is UserLoaded) {
              return buildColumnWithData(state.user);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: UsernameInput(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Builds widgets from the user data
  Widget buildColumnWithData(User user) {
    String textLabel = user == null
        ? 'user not found!'
        : 'Github\'s ${user.login} is actually:\n${user.name}';
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(textLabel),
        UsernameInput(),
      ],
    ));
  }
}

class UsernameInput extends StatefulWidget {
  const UsernameInput({
    Key key,
  }) : super(key: key);

  @override
  _UsernameInputState createState() => _UsernameInputState();
}

class _UsernameInputState extends State<UsernameInput> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        height: 50.0,
      ),
      TextField(
        controller: _textFieldController,
      ),
      RaisedButton(
        child: Text(
          'Submit',
          style: Theme.of(context).textTheme.button,
        ),
        disabledColor: Colors.grey,
        color: Theme.of(context).primaryColor,
        onPressed: isEmpty(_textFieldController.text)
            ? null
            : () {
                final String username = _textFieldController.text;
                final userBloc = BlocProvider.of<UserBloc>(context);
                // Initiate getting the user
                userBloc.dispatch(GetUserFullName(username: username));
              },
      ),
    ]);
  }
}
