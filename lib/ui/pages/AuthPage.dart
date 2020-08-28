import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'dart:async';
import 'package:nexus_mobile_app/ui/theme.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  TextEditingController domainTextController = TextEditingController();

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final double _width = 384.0;
  Animation _animation;
  double _animationValue = 0;
  final GlobalKey _globalKey = GlobalKey();

  final FocusNode _domainFocus = FocusNode();

  bool _autoValidateD = false;

  AnimationController controller;

  final FocusNode _unFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();

  bool _autoValidateUN = false;
  bool _autoValidatePW = false;
  bool _nextBtnLoading = false;

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
    _checkDomain();
  }

  void _checkDomain() async {
    final dom = await AuthorizedClient.domain;
    domainTextController.text = dom ?? '';
  }

  @override
  Widget build(BuildContext mainContext) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        body: Builder(builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Container(
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
    Widget child;
    if (state is AuthenticationStateInitialized) {
      child = buildAuthForm(state);
    } else {
      child = Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
                controller: domainTextController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autovalidate: _autoValidateD,
                focusNode: _domainFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  setState(() {
                    _autoValidateD = true;
                  });
                  _domainFocus.unfocus();
                },
                validator: (val) =>
                    val.isEmpty ? 'Domain can\'t be empty.' : null,
                decoration: InputDecoration(
                  hintText: 'Domain (nexus.example.com)',
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                key: _globalKey,
                height: 48.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(8.0),
                  onPressed: () async {
                    setState(() {
                      _nextBtnLoading = true;
                    });
                    await Future.wait([
                      AuthorizedClient.setDomain(domainTextController.text),
                      AuthorizedClient.openSignIn()
                    ]);
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      setState(() {
                        _nextBtnLoading = false;
                      });
                    });
                  },
                  child: _nextBtnLoading
                      ? CircularProgressIndicator()
                      : Text('Next'),
                )),
          ),
        ],
      );
    }
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
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
          child
        ],
      ),
    );
  }

  Widget buildAuthForm(state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
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
              decoration: InputDecoration(
                hintText: 'Username',
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: passwordTextController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autovalidate: _autoValidatePW,
            focusNode: _pwFocus,
            onFieldSubmitted: (term) {
              _pwFocus.unfocus();
              setState(() {
                _autoValidatePW = true;
                onSubmit();
              });
            },
            autocorrect: false,
            validator: (val) =>
                val.isEmpty ? 'Password can\'t be empty.' : null,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            key: _globalKey,
            height: 48.0,
            width: _width - ((_width - 48.0) * _animationValue),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(16.0 + (8 * _animationValue)))),
                padding: EdgeInsets.all(8.0),
                color: getColor(state),
                onPressed: () {},
                child: buildButtonChild(),
                onHighlightChanged: (isPressed) {
                  setState(() {
                    if (state != AuthenticationStateAuthenticating ||
                        state != AuthenticationStateAuthenticationError) {
                      onSubmit();
                    }
                  });
                }),
          ),
        )
      ],
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
    return Text('Sign In',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }
}
