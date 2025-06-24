// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChallengeController on ChallengeControllerStore, Store {
  Computed<ChallengeModel>? _$challengeComputed;

  @override
  ChallengeModel get challenge =>
      (_$challengeComputed ??= Computed<ChallengeModel>(() => super.challenge,
              name: 'ChallengeControllerStore.challenge'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'ChallengeControllerStore.isLoading'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'ChallengeControllerStore.hasError'))
          .value;

  late final _$_challengeAtom =
      Atom(name: 'ChallengeControllerStore._challenge', context: context);

  @override
  ChallengeModel get _challenge {
    _$_challengeAtom.reportRead();
    return super._challenge;
  }

  @override
  set _challenge(ChallengeModel value) {
    _$_challengeAtom.reportWrite(value, super._challenge, () {
      super._challenge = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: 'ChallengeControllerStore._isLoading', context: context);

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
      Atom(name: 'ChallengeControllerStore._hasError', context: context);

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

  late final _$_challengeIdAtom =
      Atom(name: 'ChallengeControllerStore._challengeId', context: context);

  @override
  String get _challengeId {
    _$_challengeIdAtom.reportRead();
    return super._challengeId;
  }

  @override
  set _challengeId(String value) {
    _$_challengeIdAtom.reportWrite(value, super._challengeId, () {
      super._challengeId = value;
    });
  }

  late final _$onInializeAsyncAction =
      AsyncAction('ChallengeControllerStore.onInialize', context: context);

  @override
  Future<void> onInialize() {
    return _$onInializeAsyncAction.run(() => super.onInialize());
  }

  late final _$getChallengeAsyncAction =
      AsyncAction('ChallengeControllerStore.getChallenge', context: context);

  @override
  Future<void> getChallenge() {
    return _$getChallengeAsyncAction.run(() => super.getChallenge());
  }

  @override
  String toString() {
    return '''
challenge: ${challenge},
isLoading: ${isLoading},
hasError: ${hasError}
    ''';
  }
}
