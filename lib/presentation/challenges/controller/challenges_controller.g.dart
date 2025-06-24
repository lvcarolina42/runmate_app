// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChallengesController on ChallengesControllerStore, Store {
  Computed<ObservableList<ChallengeModel>>? _$challengesComputed;

  @override
  ObservableList<ChallengeModel> get challenges => (_$challengesComputed ??=
          Computed<ObservableList<ChallengeModel>>(() => super.challenges,
              name: 'ChallengesControllerStore.challenges'))
      .value;
  Computed<ObservableList<ChallengeModel>>? _$challengesAllComputed;

  @override
  ObservableList<ChallengeModel> get challengesAll =>
      (_$challengesAllComputed ??= Computed<ObservableList<ChallengeModel>>(
              () => super.challengesAll,
              name: 'ChallengesControllerStore.challengesAll'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'ChallengesControllerStore.isLoading'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'ChallengesControllerStore.hasError'))
          .value;

  late final _$_challengesAtom =
      Atom(name: 'ChallengesControllerStore._challenges', context: context);

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

  late final _$_searchedChallengesAtom = Atom(
      name: 'ChallengesControllerStore._searchedChallenges', context: context);

  @override
  ObservableList<ChallengeModel> get _searchedChallenges {
    _$_searchedChallengesAtom.reportRead();
    return super._searchedChallenges;
  }

  @override
  set _searchedChallenges(ObservableList<ChallengeModel> value) {
    _$_searchedChallengesAtom.reportWrite(value, super._searchedChallenges, () {
      super._searchedChallenges = value;
    });
  }

  late final _$_challengesAllAtom =
      Atom(name: 'ChallengesControllerStore._challengesAll', context: context);

  @override
  ObservableList<ChallengeModel> get _challengesAll {
    _$_challengesAllAtom.reportRead();
    return super._challengesAll;
  }

  @override
  set _challengesAll(ObservableList<ChallengeModel> value) {
    _$_challengesAllAtom.reportWrite(value, super._challengesAll, () {
      super._challengesAll = value;
    });
  }

  late final _$_searchedChallengesAllAtom = Atom(
      name: 'ChallengesControllerStore._searchedChallengesAll',
      context: context);

  @override
  ObservableList<ChallengeModel> get _searchedChallengesAll {
    _$_searchedChallengesAllAtom.reportRead();
    return super._searchedChallengesAll;
  }

  @override
  set _searchedChallengesAll(ObservableList<ChallengeModel> value) {
    _$_searchedChallengesAllAtom
        .reportWrite(value, super._searchedChallengesAll, () {
      super._searchedChallengesAll = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: 'ChallengesControllerStore._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_hasErrorAtom =
      Atom(name: 'ChallengesControllerStore._hasError', context: context);

  @override
  bool get _hasError {
    _$_hasErrorAtom.reportRead();
    return super._hasError;
  }

  @override
  set _hasError(bool value) {
    _$_hasErrorAtom.reportWrite(value, super._hasError, () {
      super._hasError = value;
    });
  }

  late final _$getActiveChallengesAsyncAction = AsyncAction(
      'ChallengesControllerStore.getActiveChallenges',
      context: context);

  @override
  Future<void> getActiveChallenges() {
    return _$getActiveChallengesAsyncAction
        .run(() => super.getActiveChallenges());
  }

  late final _$getAllChallengesAsyncAction = AsyncAction(
      'ChallengesControllerStore.getAllChallenges',
      context: context);

  @override
  Future<void> getAllChallenges() {
    return _$getAllChallengesAsyncAction.run(() => super.getAllChallenges());
  }

  late final _$ChallengesControllerStoreActionController =
      ActionController(name: 'ChallengesControllerStore', context: context);

  @override
  void searchChallenges(String query) {
    final _$actionInfo = _$ChallengesControllerStoreActionController
        .startAction(name: 'ChallengesControllerStore.searchChallenges');
    try {
      return super.searchChallenges(query);
    } finally {
      _$ChallengesControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchChallengesAll(String query) {
    final _$actionInfo = _$ChallengesControllerStoreActionController
        .startAction(name: 'ChallengesControllerStore.searchChallengesAll');
    try {
      return super.searchChallengesAll(query);
    } finally {
      _$ChallengesControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
challenges: ${challenges},
challengesAll: ${challengesAll},
isLoading: ${isLoading},
hasError: ${hasError}
    ''';
  }
}
