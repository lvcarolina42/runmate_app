import 'package:get_it/get_it.dart';
import 'package:runmate_app/data/api/go_api_handler_impl.dart';
import 'package:runmate_app/data/api/client/go_default_client.dart';
import 'package:runmate_app/data/chat/datasource/chat_datasource.dart';
import 'package:runmate_app/data/chat/repository/chat_repository_impl.dart';
import 'package:runmate_app/data/events/datasource/events_datasource.dart';
import 'package:runmate_app/data/events/repository/events_repository_impl.dart';
import 'package:runmate_app/data/run/datasource/run_datasource.dart';
import 'package:runmate_app/data/user/datasource/user_datasource.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_all_challenges_use_case.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_challenge_by_id_use_case.dart';
import 'package:runmate_app/domain/chat/repository/chat_repository.dart';
import 'package:runmate_app/domain/chat/use_cases/connect_chat_use_case.dart';
import 'package:runmate_app/domain/chat/use_cases/disconnect_chat_use_case.dart';
import 'package:runmate_app/domain/chat/use_cases/get_messages_use_case.dart';
import 'package:runmate_app/domain/chat/use_cases/send_message_use_case.dart';
import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/events/use_cases/create_events_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/get_all_events_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/get_my_events_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/join_event_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/leave_event_use_case.dart';
import 'package:runmate_app/domain/notifications/notification_handler.dart';
import 'package:runmate_app/domain/run/repository/run_repository.dart';
import 'package:runmate_app/domain/user/use_cases/add_friend_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/delete_goal_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/get_friends_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/get_user_by_id_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/get_users_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/login_use_case.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/data/run/repository/run_repository_impl.dart';
import 'package:runmate_app/domain/user/use_cases/register_use_case.dart';
import 'package:runmate_app/domain/run/use_cases/create_run_use_case.dart';
import 'package:runmate_app/domain/run/use_cases/get_all_run_use_case.dart';
import 'package:runmate_app/data/user/repository/user_repository_impl.dart';
import 'package:runmate_app/domain/run/use_cases/get_run_by_user_use_case.dart';
import 'package:runmate_app/data/challenge/datasource/challenge_datasource.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';
import 'package:runmate_app/data/challenge/repository/challenge_repository_impl.dart';
import 'package:runmate_app/domain/challenge/use_cases/create_challenge_use_case.dart';
import 'package:runmate_app/domain/challenge/use_cases/join_the_challenge_use_case.dart';
import 'package:runmate_app/domain/challenge/use_cases/get_active_challenges_by_user_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/remove_friend_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/update_goal_use_case.dart';
import 'package:runmate_app/domain/user/use_cases/update_token_use_case.dart';
import 'package:runmate_app/shared/services/firebase_notifications_service.dart';

class DependencyInjector {
  final GetIt _getIt = GetIt.I;

  void setup() {
    _registerApiClient();
    _registerDatasources();
    _registerRepository();
    _registerUseCase();
    _registerNotificationServices();
  }

  void _registerNotificationServices() {
    _getIt.registerLazySingleton<NotificationHandler>(
      () => NotificationHandler(),
    );
    _getIt.registerLazySingleton<FirebaseNotificationsService>(
      () => FirebaseNotificationsService(),
    );
  }

  void _registerApiClient() {
    _getIt.registerFactory<GoDefaultClient>(
      () => GoDefaultClient(),
      instanceName: 'GoDefaultClient',
    );
    _getIt.registerFactory<GoApiHandlerImpl>(
      () => GoApiHandlerImpl(
        _getIt(instanceName: 'GoDefaultClient'),
      ),
    );
  }

  void _registerDatasources() {
    _getIt.registerFactory<UserDatasource>(
      () => UserDatasource(apiHandler: _getIt()),
    );
    _getIt.registerFactory<RunDatasource>(
      () => RunDatasource(apiHandler: _getIt()),
    );
    _getIt.registerFactory<ChallengeDatasource>(
      () => ChallengeDatasource(apiHandler: _getIt()),
    );
    _getIt.registerLazySingleton<ChatDatasource>(
      () => ChatDatasource(apiHandler: _getIt<GoApiHandlerImpl>()),
    );
    _getIt.registerLazySingleton<EventsDatasource>(
      () => EventsDatasource(apiHandler: _getIt<GoApiHandlerImpl>()),
    );
  }

  void _registerRepository() {
    _getIt.registerFactory<UserRepository>(
      () => UserRepositoryImpl(datasource: _getIt()),
    );
    _getIt.registerFactory<RunRepository>(
      () => RunRepositoryImpl(datasource: _getIt()),
    );
    _getIt.registerFactory<ChallengeRepository>(
      () => ChallengeRepositoryImpl(datasource: _getIt()),
    );
    _getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(datasource: _getIt<ChatDatasource>()),
    );
    _getIt.registerFactory<EventsRepository>(
      () => EventsRepositoryImpl(datasource: _getIt()),
    );
  }

  void _registerUseCase() {
    _getIt.registerFactory(
      () => RegisterUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => LoginUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetFriendsUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetUsersUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => AddFriendUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => RemoveFriendUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetUserByIdUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => UpdateTokenUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => DeleteGoalUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => UpdateGoalUseCase(repository: _getIt()),
    );

    _getIt.registerFactory(
      () => CreateRunUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetAllRunUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetRunByUserUseCase(repository: _getIt()),
    );

    _getIt.registerFactory(
      () => GetActiveChallengesByUserUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => CreateChallengeUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => JoinTheChallengeUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetChallengeByIdUseCase(repository: _getIt()),
    );

    _getIt.registerFactory(
      () => ConnectChatUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => DisconnectChatUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => SendMessageUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetMessagesUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetAllChallengesUseCase(repository: _getIt()),
    );

    _getIt.registerFactory(
      () => GetMyEventsUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => GetAllEventsUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => CreateEventsUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => JoinEventUseCase(repository: _getIt()),
    );
    _getIt.registerFactory(
      () => LeaveEventUseCase(repository: _getIt()),
    );
  }
}
