import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_active_challenges_by_user_use_case.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_all_challenges_use_case.dart';
import 'package:runmate_app/domain/challenge/use_cases/join_the_challenge_use_case.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/shared/events/app_listener_events.dart';

part 'challenges_controller.g.dart';

class ChallengesController = ChallengesControllerStore with _$ChallengesController;

abstract class ChallengesControllerStore extends DisposableInterface with Store {
  final GetAllChallengesUseCase getAllChallengesUseCase;
  final JoinTheChallengeUseCase joinTheChallengeUseCase;
  final GetActiveChallengesByUserUseCase getActiveChallengesByUserUseCase;

  ChallengesControllerStore({
    required this.getAllChallengesUseCase,
    required this.joinTheChallengeUseCase,
    required this.getActiveChallengesByUserUseCase,
  });

  final User? _user = SessionManager().currentUser;

  @observable
  ObservableList<ChallengeModel> _challenges = ObservableList<ChallengeModel>();

  @observable
  ObservableList<ChallengeModel> _searchedChallenges = ObservableList<ChallengeModel>();

  @computed
  ObservableList<ChallengeModel> get challenges => _searchedChallenges.isEmpty ? _challenges : _searchedChallenges;

  @observable
  ObservableList<ChallengeModel> _challengesAll = ObservableList<ChallengeModel>();

  @observable
  ObservableList<ChallengeModel> _searchedChallengesAll = ObservableList<ChallengeModel>();

  @computed
  ObservableList<ChallengeModel> get challengesAll => _searchedChallengesAll.isEmpty ? _challengesAll : _searchedChallengesAll;

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

  final joinChallengeController = TextEditingController();

  int userDistance (ChallengeModel challenge) {
    final user = _user;
    if (user == null) return 0;
    
    final challengeUser = challenge.ranking.firstWhereOrNull((e) => e.user.id == user.id);

    return challengeUser?.distance ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    onInialize();
  }

  Future<void> onInialize() async {
    await getActiveChallenges();
    await getAllChallenges();
    searchController.addListener(() {
      searchChallenges(searchController.text);
    });

    searchControllerAll.addListener(() {
      searchChallengesAll(searchControllerAll.text);
    });

    AppListenerEvents().on<ChallengeEvent>(() async {
      await getActiveChallenges();
    });

    AppListenerEvents().on<RunEvent>(() async {
      await getActiveChallenges();
    });
  }

  @action
  void searchChallenges(String query) {
    if (query.isNotEmpty) {
      _searchedChallenges = <ChallengeModel>[].asObservable();
      _searchedChallenges = _challenges.where((challenge) => challenge.title.toLowerCase().contains(query.toLowerCase())).toList().asObservable();
    } else {
      _searchedChallenges.clear();
    }
  }

  @action
  void searchChallengesAll(String query) {
    if (query.isNotEmpty) {
      _searchedChallengesAll = <ChallengeModel>[].asObservable();
      _searchedChallengesAll = _challengesAll.where((challenge) => challenge.title.toLowerCase().contains(query.toLowerCase())).toList().asObservable();
    } else {
      _searchedChallengesAll.clear();
    }
  }

  @action
  Future<void> getActiveChallenges() async {
    _isLoading = true;
    final result = await getActiveChallengesByUserUseCase(_user!.id);

    result.processResult(
      onSuccess: (data) {
        _challenges = data.asObservable();
      },
      onFailure: (error) {
        _hasError = true;
      },
    );

    _isLoading = false;
  }

  @action
  Future<void> getAllChallenges() async {
    final result = await getAllChallengesUseCase(_user!.id);

    result.processResult(
      onSuccess: (data) {
        _challengesAll = data.asObservable();
      },
      onFailure: (error) {
      },
    );

  }

  Future<void> joinChallenge(String challengeId) async {
    final result = await joinTheChallengeUseCase(
      challengeId: challengeId,
      userId: _user!.id,
    );

    result.processResult(
      onSuccess: (data) async {
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
            content: const Text("Erro ao entrar no desafio"),
          ),
        );
      },
    );
    AppListenerEvents().add(ChallengeEvent());
  }
}

