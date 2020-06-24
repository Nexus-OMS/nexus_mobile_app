import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/enum/TaskStatus.dart';
import 'package:nexus_mobile_app/NColors.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  BuildContext _scaffoldContext;
  TextEditingController usernameTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();

  List<Color> colors;

  bool _isPressed = false;
  bool _animatingReveal = false;
  int _state = 0;
  double _width = 384.0;
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();

  FocusNode _unFocus = FocusNode();
  FocusNode _pwFocus = FocusNode();

  bool _autoValidateUN = false;
  bool _autoValidatePW = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {
    colors = [NColors.primary, NColors.primary, Colors.green, NColors.danger];
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
                child: new Form(
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
                            validator: (val) => val.isEmpty
                                ? 'Username can\'t be empty.'
                                : null,
                            decoration: new InputDecoration(
                              filled: true,
                              hintText: 'Username',
                              fillColor: NColors.lightGrey,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: NColors.danger),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: NColors.primary),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: NColors.warning),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: NColors.lightGrey),
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
                              animateButton();
                            });
                          },
                          autocorrect: false,
                          validator: (val) =>
                              val.isEmpty ? 'Password can\'t be empty.' : null,
                          obscureText: true,
                          decoration: new InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: NColors.lightGrey,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: NColors.danger),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: NColors.primary),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: NColors.warning),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: NColors.lightGrey),
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
                          width: _width,
                          child: new RaisedButton(
                              shape: getCorners(),
                              padding: EdgeInsets.all(8.0),
                              color: colors[_state],
                              onPressed: () {},
                              child: buildButtonChild(),
                              onHighlightChanged: (isPressed) {
                                setState(() {
                                  _isPressed = isPressed;
                                  if (_state == 0) {
                                    animateButton();
                                  }
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }

  RoundedRectangleBorder getCorners() {
    if (_state != 0)
      return new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(24.0)));
    return new RoundedRectangleBorder(
        borderRadius: new BorderRadius.all(new Radius.circular(16.0)));
  }

  void animateButton() {
    final form = formKey.currentState;
    if (!form.validate()) {
      return;
    }
    double initialWidth = _width;

    var controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });

    controller.forward();

    setState(() {
      _state = 1;
    });

    attemptAuthentication(context).then((a) async {
      if (a == TaskStatus.FAILURE) {
        setState(() {
          _state = 3;
        });
        await new Future.delayed(const Duration(seconds: 3));

        controller.reverse();

        setState(() {
          _state = 0;
        });
      } else {
        setState(() {
          _state = 2;
        });
      }
    });
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return new Text('Sign In',
          style:
              new TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    } else if (_state == 1) {
      return SizedBox(
          height: 24.0,
          width: 24.0,
          child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    } else if (_state == 2) {
      return Icon(Icons.check, color: Colors.white);
    }
    return Icon(Icons.close, color: Colors.white);
  }

  Future<TaskStatus> attemptAuthentication(BuildContext mainContext) async {
    debugPrint(' - Attempting to Authenticate - ');
    debugPrint('\tUsername: ' + usernameTextController.text);
    debugPrint('\tPassword: ' + passwordTextController.text);
    var value = await AuthorizedClient.authenticate(
        username: usernameTextController.text,
        password: passwordTextController.text);
    debugPrint('\tStatus: ' + value.toString());
    if (value == TaskStatus.SUCCESS) {
      Timer(new Duration(seconds: 2), () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      });
    } else {
      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
        content: new Text("There was an issue signing in."),
      ));
      return TaskStatus.FAILURE;
    }
  }
}
