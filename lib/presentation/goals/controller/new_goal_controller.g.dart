// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_goal_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewGoalController on NewGoalControllerStore, Store {
  Computed<User?>? _$userComputed;

  @override
  User? get user => (_$userComputed ??= Computed<User?>(() => super.user,
          name: 'NewGoalControllerStore.user'))
      .value;

  late final _$_userAtom =
      Atom(name: 'NewGoalControllerStore._user', context: context);

  @override
  User? get _user {
    _$_userAtom.reportRead();
    return super._user;
  }

  @override
  set _user(User? value) {
    _$_userAtom.reportWrite(value, super._user, () {
      super._user = value;
    });
  }

  late final _$nameAtom =
      Atom(name: 'NewGoalControllerStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: 'NewGoalControllerStore.description', context: context);

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$NewGoalControllerStoreActionController =
      ActionController(name: 'NewGoalControllerStore', context: context);

  @override
  void setName(String value) {
    final _$actionInfo = _$NewGoalControllerStoreActionController.startAction(
        name: 'NewGoalControllerStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$NewGoalControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$NewGoalControllerStoreActionController.startAction(
        name: 'NewGoalControllerStore.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$NewGoalControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
description: ${description},
user: ${user}
    ''';
  }
}
