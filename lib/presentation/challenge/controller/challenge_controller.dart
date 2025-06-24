import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_challenge_by_id_use_case.dart';
import 'package:runmate_app/domain/user/session_manager.dart';

part 'challenge_controller.g.dart';

class ChallengeController = ChallengeControllerStore with _$ChallengeController;

abstract class ChallengeControllerStore extends DisposableInterface with Store {
  final GetChallengeByIdUseCase getChallengeByIdUseCase;

  ChallengeControllerStore({required this.getChallengeByIdUseCase});

  @observable
  ChallengeModel _challenge = ChallengeModel.empty();

  @computed
  ChallengeModel get challenge => _challenge;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  bool _hasError = false;

  @computed
  bool get hasError => _hasError;

  final TextEditingController searchController = TextEditingController();

  @observable
  String _challengeId = "";

  int userDistance () {
    final user = SessionManager().currentUser;
    if (user == null) return 0;
    
    final challengeUser = challenge.ranking.firstWhereOrNull((e) => e.user.id == user.id);

    return challengeUser?.distance ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    onInialize();
  }

  @action
  Future<void> onInialize() async {
    final args = Get.arguments as String;
    _challengeId = args;

    await getChallenge();
  }

  @action
  Future<void> getChallenge() async {
    _isLoading = true;
    final result = await getChallengeByIdUseCase(id: _challengeId);

    result.processResult(
      onSuccess: (data) {
        _challenge = data;
      },
      onFailure: (error) {
        _hasError = true;
      },
    );

    _isLoading = false;
  }
}

