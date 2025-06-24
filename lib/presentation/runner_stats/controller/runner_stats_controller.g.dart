// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner_stats_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RunnerStatsController on RunnerStatsControllerStore, Store {
  Computed<User?>? _$userComputed;

  @override
  User? get user => (_$userComputed ??= Computed<User?>(() => super.user,
          name: 'RunnerStatsControllerStore.user'))
      .value;

  late final _$_userAtom =
      Atom(name: 'RunnerStatsControllerStore._user', context: context);

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

  @override
  String toString() {
    return '''
user: ${user}
    ''';
  }
}
