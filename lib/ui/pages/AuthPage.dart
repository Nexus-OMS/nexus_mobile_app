import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'dart:async';
import 'package:nexus_mobile_app/ui/theme.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  BuildContext _scaffoldContext;
  TextEditingController usernameTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();

  bool _isPressed = false;
  bool _animatingReveal = false;
  int _state = 0;
  double _width = 384.0;
  Animation _animation;
  double _animationValue = 0;
  GlobalKey _globalKey = GlobalKey();

  FocusNode _unFocus = FocusNode();
  FocusNode _pwFocus = FocusNode();

  bool _autoValidateUN = false;
  bool _autoValidatePW = false;

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _animationValue = _animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext mainContext) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return new Scaffold(
        backgroundColor: Colors.white,
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return new Container(
              padding: new EdgeInsets.all(16.0),
              width: 384,
              child: new Center(
                child: new Container(
                  padding: EdgeInsets.all(24.0),
                  child: buildForm(state),
                ),
              ));
        }),
      );
    });
  }

  @override
  void didUpdateWidget(AuthPage oldWidget) {
    runAnimation();
    super.didUpdateWidget(oldWidget);
  }

  void runAnimation() {
    var state = BlocProvider.of<AuthenticationBloc>(context).state;
    if (state is AuthenticationStateAuthenticating) {
      controller.forward();
    } else if (state is AuthenticationStateAuthenticationErrorCleared) {
      controller.reverse();
    } else if (state is AuthenticationStateAuthenticationError) {
      if (!controller.isCompleted) controller.forward();
      Future.delayed(const Duration(seconds: 2)).then((val) {
        context.bloc<AuthenticationBloc>().add(AuthenticationEventClearError());
      });
    } else if (controller.isCompleted) {
      controller.reverse();
    }
  }

  Widget buildForm(state) {
    return Form(
      key: formKey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: Hero(
              tag: 'app_icon',
              child: Image.asset(
                'assets/icon/icon_transparent.png',
                width: 100.0,
                height: 100.0,
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new TextFormField(
                controller: usernameTextController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autovalidate: _autoValidateUN,
                focusNode: _unFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  setState(() {
                    _autoValidateUN = true;
                  });
                  _unFocus.unfocus();
                  FocusScope.of(context).requestFocus(_pwFocus);
                },
                validator: (val) =>
                    val.isEmpty ? 'Username can\'t be empty.' : null,
                decoration: new InputDecoration(
                  filled: true,
                  hintText: 'Username',
                  fillColor: NexusTheme.lightGrey,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: NexusTheme.danger),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: NexusTheme.primary),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: NexusTheme.warning),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: NexusTheme.lightGrey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                )),
          ),
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new TextFormField(
              controller: passwordTextController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              autovalidate: _autoValidatePW,
              focusNode: _pwFocus,
              onFieldSubmitted: (term) {
                _pwFocus.unfocus();
                setState(() {
                  _isPressed = true;
                  _autoValidatePW = true;
                  onSubmit();
                });
              },
              autocorrect: false,
              validator: (val) =>
                  val.isEmpty ? 'Password can\'t be empty.' : null,
              obscureText: true,
              decoration: new InputDecoration(
                hintText: 'Password',
                filled: true,
                fillColor: NexusTheme.lightGrey,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.0),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: NexusTheme.danger),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: NexusTheme.primary),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: NexusTheme.warning),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: NexusTheme.lightGrey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Container(
              key: _globalKey,
              height: 48.0,
              width: _width - ((_width - 48.0) * _animationValue),
              child: new RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(16.0 + (8 * _animationValue)))),
                  padding: EdgeInsets.all(8.0),
                  color: getColor(state),
                  onPressed: () {},
                  child: buildButtonChild(),
                  onHighlightChanged: (isPressed) {
                    setState(() {
                      _isPressed = isPressed;
                      if (state != AuthenticationStateAuthenticating ||
                          state != AuthenticationStateAuthenticationError) {
                        onSubmit();
                      }
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(AuthenticationState state) {
    if (state is AuthenticationStateAuthenticationError) {
      return NexusTheme.danger;
    } else {
      return NexusTheme.primary;
    }
  }

  void onSubmit() {
    final form = formKey.currentState;
    if (!form.validate()) {
      return;
    }
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationEventSignInCredentials(
            usernameTextController.text, passwordTextController.text));
  }

  Widget buildButtonChild() {
    var state = BlocProvider.of<AuthenticationBloc>(context).state;
    if (state is AuthenticationStateAuthenticationError) {
      return Icon(Icons.close, color: Colors.white);
    } else if (state is AuthenticationStateAuthenticating) {
      return SizedBox(
          height: 24.0,
          width: 24.0,
          child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    }
    return new Text('Sign In',
        style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }
}
