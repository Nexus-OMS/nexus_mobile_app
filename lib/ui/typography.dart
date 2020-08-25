import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String text;
  H1(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline4);
  }
}

class H2 extends StatelessWidget {
  final String text;
  H2(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline3);
  }
}

class H3 extends StatelessWidget {
  final String text;
  H3(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline2);
  }
}

class H4 extends StatelessWidget {
  final String text;
  H4(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline1);
  }
}

class TextTitle extends StatelessWidget {
  final String text;
  TextTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline6);
  }
}

class Headline extends StatelessWidget {
  final String text;
  Headline(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline5);
  }
}

class Subtitle extends StatelessWidget {
  final String text;
  Subtitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.subtitle2);
  }
}

class MenuText extends StatelessWidget {
  final String text;
  MenuText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 28));
  }
}

class MenuTripText extends StatelessWidget {
  final String text;
  MenuTripText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(fontSize: 28, color: Theme.of(context).accentColor, fontWeight: FontWeight.bold));
  }
}
