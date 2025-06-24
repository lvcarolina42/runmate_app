// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostController on PostControllerStore, Store {
  Computed<Run?>? _$runComputed;

  @override
  Run? get run => (_$runComputed ??=
          Computed<Run?>(() => super.run, name: 'PostControllerStore.run'))
      .value;

  late final _$_runAtom =
      Atom(name: 'PostControllerStore._run', context: context);

  @override
  Run? get _run {
    _$_runAtom.reportRead();
    return super._run;
  }

  @override
  set _run(Run? value) {
    _$_runAtom.reportWrite(value, super._run, () {
      super._run = value;
    });
  }

  @override
  String toString() {
    return '''
run: ${run}
    ''';
  }
}
