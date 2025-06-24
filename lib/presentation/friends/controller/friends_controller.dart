import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/user/use_cases/add_friend_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/get_friends_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/get_users_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/remove_friend_use_case.dart';
import 'package:runmate_app/shared/events/app_listener_events.dart';

part 'friends_controller.g.dart';

class FriendsController = FriendsControllerStore with _$FriendsController;

abstract class FriendsControllerStore extends DisposableInterface with Store {
  final GetUsersUseCase getUsersUseCase;
  final AddFriendUseCase addFriendUseCase;
  final GetFriendsUseCase getFriendsUseCase;
  final RemoveFriendUseCase removeFriendUseCase;

  FriendsControllerStore({
    required this.getUsersUseCase,
    required this.addFriendUseCase,
    required this.getFriendsUseCase,
    required this.removeFriendUseCase,
  });

  final User? _user = SessionManager().currentUser;

  @observable
  ObservableList<User> _users = ObservableList<User>();

  @observable
  ObservableList<User> _searchedUsers = ObservableList<User>();

  @computed
  ObservableList<User> get users => _searchedUsers.isEmpty ? _users : _searchedUsers;

  @observable
  ObservableList<User> _usersAll = ObservableList<User>();

  @observable
  ObservableList<User> _searchedUsersAll = ObservableList<User>();

  @computed
  ObservableList<User> get usersAll => _searchedUsersAll.isEmpty ? _usersAll : _searchedUsersAll;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  bool _hasError = false;

  @computed
  bool get hasError => _hasError;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchControllerAll = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    onInialize();
  }

  Future<void> onInialize() async {
    await getUsers();
    await getFriends();
    searchController.addListener(() {
      searchUsers(searchController.text);
    });

    searchControllerAll.addListener(() {
      searchUsersAll(searchControllerAll.text);
    });
  }

  @action
  void searchUsers(String query) {
    if (query.isNotEmpty) {
      _searchedUsers = <User>[].asObservable();
      _searchedUsers = _users.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList().asObservable();
    } else {
      _searchedUsers.clear();
    }
  }

  @action
  void searchUsersAll(String query) {
    if (query.isNotEmpty) {
      _searchedUsersAll = <User>[].asObservable();
      _searchedUsersAll = _usersAll.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList().asObservable();
    } else {
      _searchedUsersAll.clear();
    }
  }

  @action
  Future<void> getUsers() async {
    final result = await getUsersUseCase(id: _user!.id);

    result.processResult(
      onSuccess: (data) {
        _usersAll = data.asObservable();
      },
      onFailure: (error) {
      },
    );
  }

  @action
  Future<void> getFriends() async {
    final result = await getFriendsUseCase(id: _user!.id);

    result.processResult(
      onSuccess: (data) {
        _users = data.asObservable();
      },
      onFailure: (error) {
      },
    );
  }

  @action
  Future<void> addFriend(String userId) async {
    final result = await addFriendUseCase(userId: _user!.id, friendId: userId);

    result.processResult(
      onSuccess: (data) async {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Amigo adicionado com sucesso"),
          ),
        );
        await onInialize();
      },
      onFailure: (error) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Erro ao adicionar amigo"),
          ),
        );
      },
    );
    AppListenerEvents().add(UserEvent());

  }

  @action
  Future<void> removeFriend(String userId) async {
    final result = await removeFriendUseCase(userId: _user!.id, friendId: userId);

    result.processResult(
      onSuccess: (data) async {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Amigo removido com sucesso"),
          ),
        );
        await onInialize();
      },
      onFailure: (error) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Erro ao remover amigo"),
          ),
        );
      },
    );
    AppListenerEvents().add(UserEvent());

  }
}

