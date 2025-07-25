// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MenuPageController on MenuPageControllerStore, Store {
  Computed<int>? _$currentIndexComputed;

  @override
  int get currentIndex =>
      (_$currentIndexComputed ??= Computed<int>(() => super.currentIndex,
              name: 'MenuPageControllerStore.currentIndex'))
          .value;

  late final _$_currentIndexAtom =
      Atom(name: 'MenuPageControllerStore._currentIndex', context: context);

  @override
  int get _currentIndex {
    _$_currentIndexAtom.reportRead();
    return super._currentIndex;
  }

  @override
  set _currentIndex(int value) {
    _$_currentIndexAtom.reportWrite(value, super._currentIndex, () {
      super._currentIndex = value;
    });
  }

  late final _$MenuPageControllerStoreActionController =
      ActionController(name: 'MenuPageControllerStore', context: context);

  @override
  void onChangePage(int index) {
    final _$actionInfo = _$MenuPageControllerStoreActionController.startAction(
        name: 'MenuPageControllerStore.onChangePage');
    try {
      return super.onChangePage(index);
    } finally {
      _$MenuPageControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex}
    ''';
  }
}
