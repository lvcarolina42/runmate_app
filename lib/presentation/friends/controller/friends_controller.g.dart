// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendsController on FriendsControllerStore, Store {
  Computed<ObservableList<User>>? _$usersComputed;

  @override
  ObservableList<User> get users =>
      (_$usersComputed ??= Computed<ObservableList<User>>(() => super.users,
              name: 'FriendsControllerStore.users'))
          .value;
  Computed<ObservableList<User>>? _$usersAllComputed;

  @override
  ObservableList<User> get usersAll => (_$usersAllComputed ??=
          Computed<ObservableList<User>>(() => super.usersAll,
              name: 'FriendsControllerStore.usersAll'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'FriendsControllerStore.isLoading'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'FriendsControllerStore.hasError'))
          .value;

  late final _$_usersAtom =
      Atom(name: 'FriendsControllerStore._users', context: context);

  @override
  ObservableList<User> get _users {
    _$_usersAtom.reportRead();
    return super._users;
  }

  @override
  set _users(ObservableList<User> value) {
    _$_usersAtom.reportWrite(value, super._users, () {
      super._users = value;
    });
  }

  late final _$_searchedUsersAtom =
      Atom(name: 'FriendsControllerStore._searchedUsers', context: context);

  @override
  ObservableList<User> get _searchedUsers {
    _$_searchedUsersAtom.reportRead();
    return super._searchedUsers;
  }

  @override
  set _searchedUsers(ObservableList<User> value) {
    _$_searchedUsersAtom.reportWrite(value, super._searchedUsers, () {
      super._searchedUsers = value;
    });
  }

  late final _$_usersAllAtom =
      Atom(name: 'FriendsControllerStore._usersAll', context: context);

  @override
  ObservableList<User> get _usersAll {
    _$_usersAllAtom.reportRead();
    return super._usersAll;
  }

  @override
  set _usersAll(ObservableList<User> value) {
    _$_usersAllAtom.reportWrite(value, super._usersAll, () {
      super._usersAll = value;
    });
  }

  late final _$_searchedUsersAllAtom =
      Atom(name: 'FriendsControllerStore._searchedUsersAll', context: context);

  @override
  ObservableList<User> get _searchedUsersAll {
    _$_searchedUsersAllAtom.reportRead();
    return super._searchedUsersAll;
  }

  @override
  set _searchedUsersAll(ObservableList<User> value) {
    _$_searchedUsersAllAtom.reportWrite(value, super._searchedUsersAll, () {
      super._searchedUsersAll = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: 'FriendsControllerStore._isLoading', context: context);

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
      Atom(name: 'FriendsControllerStore._hasError', context: context);

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

  late final _$getUsersAsyncAction =
      AsyncAction('FriendsControllerStore.getUsers', context: context);

  @override
  Future<void> getUsers() {
    return _$getUsersAsyncAction.run(() => super.getUsers());
  }

  late final _$getFriendsAsyncAction =
      AsyncAction('FriendsControllerStore.getFriends', context: context);

  @override
  Future<void> getFriends() {
    return _$getFriendsAsyncAction.run(() => super.getFriends());
  }

  late final _$addFriendAsyncAction =
      AsyncAction('FriendsControllerStore.addFriend', context: context);

  @override
  Future<void> addFriend(String userId) {
    return _$addFriendAsyncAction.run(() => super.addFriend(userId));
  }

  late final _$removeFriendAsyncAction =
      AsyncAction('FriendsControllerStore.removeFriend', context: context);

  @override
  Future<void> removeFriend(String userId) {
    return _$removeFriendAsyncAction.run(() => super.removeFriend(userId));
  }

  late final _$FriendsControllerStoreActionController =
      ActionController(name: 'FriendsControllerStore', context: context);

  @override
  void searchUsers(String query) {
    final _$actionInfo = _$FriendsControllerStoreActionController.startAction(
        name: 'FriendsControllerStore.searchUsers');
    try {
      return super.searchUsers(query);
    } finally {
      _$FriendsControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchUsersAll(String query) {
    final _$actionInfo = _$FriendsControllerStoreActionController.startAction(
        name: 'FriendsControllerStore.searchUsersAll');
    try {
      return super.searchUsersAll(query);
    } finally {
      _$FriendsControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
users: ${users},
usersAll: ${usersAll},
isLoading: ${isLoading},
hasError: ${hasError}
    ''';
  }
}
