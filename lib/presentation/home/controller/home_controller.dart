import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_active_challenges_by_user_use_case.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/run/use_cases/get_all_run_use_case.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/shared/events/app_listener_events.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerStore with _$HomeController;

abstract class HomeControllerStore extends DisposableInterface with Store {
  final GetAllRunUseCase getAllRunUseCase;
  final GetActiveChallengesByUserUseCase getActiveChallengesByUserUseCase;

  HomeControllerStore({required this.getAllRunUseCase, required this.getActiveChallengesByUserUseCase});

  @observable
  User? _user = SessionManager().currentUser;
  
  @computed
  User? get user => _user;

  @observable
  bool _isLoadingFeed = false;

  @computed
  bool get isLoadingFeed => _isLoadingFeed;

  @observable
  bool _hasErrorFeed = false;

  @computed
  bool get hasErrorFeed => _hasErrorFeed;

  @observable
  ObservableList<Run> _runs = ObservableList<Run>();

  @computed
  ObservableList<Run> get runs => _runs.reversed.toList().asObservable();

  @observable
  ObservableList<ChallengeModel> _challenges = ObservableList<ChallengeModel>();

  @computed
  ObservableList<ChallengeModel> get challenges => _challenges;

  int userDistance (ChallengeModel challenge) {
    final user = _user;
    if (user == null) return 0;
    
    final challengeUser = challenge.ranking.firstWhereOrNull((e) => e.user.id == user.id);

    return challengeUser?.distance ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await getAllRun();
    await getActiveChallenges();

    AppListenerEvents().on<ChallengeEvent>(() async {
      await getActiveChallenges();
    });

    AppListenerEvents().on<UserEvent>(() async {
      await getAllRun();
    });

    AppListenerEvents().on<RunEvent>(() async {
      await getActiveChallenges();
    });

    AppListenerEvents().on<RunEvent>(() async {
      await getAllRun();
    });
  }

  @action
  Future<void> getAllRun() async {
    final result = await getAllRunUseCase();

    result.processResult(
      onSuccess: (data) {
        _runs = data.asObservable();
      },
      onFailure: (error) {
        _hasErrorFeed = true;
      },
    );
  }

  @action
  Future<void> getActiveChallenges() async {
    final result = await getActiveChallengesByUserUseCase(_user!.id);

    result.processResult(
      onSuccess: (data) {
        _challenges = data.asObservable();
      },
      onFailure: (error) {
        
      },
    );
  }
}

