// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on HomeControllerStore, Store {
  Computed<User?>? _$userComputed;

  @override
  User? get user => (_$userComputed ??=
          Computed<User?>(() => super.user, name: 'HomeControllerStore.user'))
      .value;
  Computed<bool>? _$isLoadingFeedComputed;

  @override
  bool get isLoadingFeed =>
      (_$isLoadingFeedComputed ??= Computed<bool>(() => super.isLoadingFeed,
              name: 'HomeControllerStore.isLoadingFeed'))
          .value;
  Computed<bool>? _$hasErrorFeedComputed;

  @override
  bool get hasErrorFeed =>
      (_$hasErrorFeedComputed ??= Computed<bool>(() => super.hasErrorFeed,
              name: 'HomeControllerStore.hasErrorFeed'))
          .value;
  Computed<ObservableList<Run>>? _$runsComputed;

  @override
  ObservableList<Run> get runs =>
      (_$runsComputed ??= Computed<ObservableList<Run>>(() => super.runs,
              name: 'HomeControllerStore.runs'))
          .value;
  Computed<ObservableList<ChallengeModel>>? _$challengesComputed;

  @override
  ObservableList<ChallengeModel> get challenges => (_$challengesComputed ??=
          Computed<ObservableList<ChallengeModel>>(() => super.challenges,
              name: 'HomeControllerStore.challenges'))
      .value;

  late final _$_userAtom =
      Atom(name: 'HomeControllerStore._user', context: context);

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

  late final _$_isLoadingFeedAtom =
      Atom(name: 'HomeControllerStore._isLoadingFeed', context: context);

  @override
  bool get _isLoadingFeed {
    _$_isLoadingFeedAtom.reportRead();
    return super._isLoadingFeed;
  }

  @override
  set _isLoadingFeed(bool value) {
    _$_isLoadingFeedAtom.reportWrite(value, super._isLoadingFeed, () {
      super._isLoadingFeed = value;
    });
  }

  late final _$_hasErrorFeedAtom =
      Atom(name: 'HomeControllerStore._hasErrorFeed', context: context);

  @override
  bool get _hasErrorFeed {
    _$_hasErrorFeedAtom.reportRead();
    return super._hasErrorFeed;
  }

  @override
  set _hasErrorFeed(bool value) {
    _$_hasErrorFeedAtom.reportWrite(value, super._hasErrorFeed, () {
      super._hasErrorFeed = value;
    });
  }

  late final _$_runsAtom =
      Atom(name: 'HomeControllerStore._runs', context: context);

  @override
  ObservableList<Run> get _runs {
    _$_runsAtom.reportRead();
    return super._runs;
  }

  @override
  set _runs(ObservableList<Run> value) {
    _$_runsAtom.reportWrite(value, super._runs, () {
      super._runs = value;
    });
  }

  late final _$_challengesAtom =
      Atom(name: 'HomeControllerStore._challenges', context: context);

  @override
  ObservableList<ChallengeModel> get _challenges {
    _$_challengesAtom.reportRead();
    return super._challenges;
  }

  @override
  set _challenges(ObservableList<ChallengeModel> value) {
    _$_challengesAtom.reportWrite(value, super._challenges, () {
      super._challenges = value;
    });
  }

  late final _$getAllRunAsyncAction =
      AsyncAction('HomeControllerStore.getAllRun', context: context);

  @override
  Future<void> getAllRun() {
    return _$getAllRunAsyncAction.run(() => super.getAllRun());
  }

  late final _$getActiveChallengesAsyncAction =
      AsyncAction('HomeControllerStore.getActiveChallenges', context: context);

  @override
  Future<void> getActiveChallenges() {
    return _$getActiveChallengesAsyncAction
        .run(() => super.getActiveChallenges());
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoadingFeed: ${isLoadingFeed},
hasErrorFeed: ${hasErrorFeed},
runs: ${runs},
challenges: ${challenges}
    ''';
  }
}
