import 'package:flutter/material.dart';

extension NavigatorGetter on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);
}

extension NavigatorHelper on NavigatorState {
  Future<T?> pushPage<T>(Widget page) {
    return push(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacementPage<T, TO>(Widget page, {TO? result}) {
    return pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page),
        result: result);
  }

  Future<T?> pushAndRemoveUntilPage<T>(Widget page,
      {bool Function(Route<dynamic>)? predicate}) {
    return pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }
}

extension NavigationExtensions on BuildContext {

  /// Pushes a route to the top of the stack
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pushes a route using root navigator
  Future<T?> pushRoot<T>(Widget page) {
    return Navigator.of(this, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pushes and replaces current route
  Future<T?> pushReplacementWith<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Pushes and removes until predicate returns true
  Future<T?> pushAndRemoveUntil<T>(Widget page,
      {bool Function(Route<dynamic>)? predicate}) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }

  /// Pops the top-most route
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Tries to pop if possible
  void maybePop<T extends Object?>([T? result]) {
    Navigator.of(this).maybePop(result);
  }

  /// Pops until predicate returns true
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// Checks whether pop is possible
  bool canPop() {
    return Navigator.of(this).canPop();
  }

  /// Pushes named route
  Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replaces current with named route
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Pushes named and removes all previous
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }
}
