// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterController on RegisterControllerStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'RegisterControllerStore.isLoading'))
          .value;

  late final _$_isLoadingAtom =
      Atom(name: 'RegisterControllerStore._isLoading', context: context);

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

  late final _$onTapRegisterAsyncAction =
      AsyncAction('RegisterControllerStore.onTapRegister', context: context);

  @override
  Future<void> onTapRegister() {
    return _$onTapRegisterAsyncAction.run(() => super.onTapRegister());
  }

  late final _$RegisterControllerStoreActionController =
      ActionController(name: 'RegisterControllerStore', context: context);

  @override
  void toggleShowPassword() {
    final _$actionInfo = _$RegisterControllerStoreActionController.startAction(
        name: 'RegisterControllerStore.toggleShowPassword');
    try {
      return super.toggleShowPassword();
    } finally {
      _$RegisterControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleShowConfirmPassword() {
    final _$actionInfo = _$RegisterControllerStoreActionController.startAction(
        name: 'RegisterControllerStore.toggleShowConfirmPassword');
    try {
      return super.toggleShowConfirmPassword();
    } finally {
      _$RegisterControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading}
    ''';
  }
}
