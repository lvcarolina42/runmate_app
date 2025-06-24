import 'package:get/get.dart';
import 'package:runmate_app/di/challenge_module.dart';
import 'package:runmate_app/di/challenges_module.dart';
import 'package:runmate_app/di/chat_module.dart';
import 'package:runmate_app/di/friends_module.dart';
import 'package:runmate_app/di/menu_module.dart';
import 'package:runmate_app/di/login_module.dart';
import 'package:runmate_app/di/new_challenge_module.dart';
import 'package:runmate_app/di/post_module.dart';
import 'package:runmate_app/di/register_module.dart';
import 'package:runmate_app/di/running_info_module.dart';
import 'package:runmate_app/di/running_module.dart';
import 'package:runmate_app/di/running_monitor_module.dart';
import 'package:runmate_app/di/user_profile_module.dart';
import 'package:runmate_app/presentation/challenge/challenge_page.dart';
import 'package:runmate_app/presentation/challenges/challenges_page.dart';
import 'package:runmate_app/presentation/chat/chat_page.dart';
import 'package:runmate_app/presentation/friends/friends_page.dart';
import 'package:runmate_app/presentation/goals/new_goal_page.dart';
import 'package:runmate_app/presentation/menu/menu_page.dart';
import 'package:runmate_app/presentation/login/login_page.dart';
import 'package:runmate_app/presentation/new_challenge/new_challenge_page.dart';
import 'package:runmate_app/presentation/post/post_page.dart';
import 'package:runmate_app/presentation/register/register_page.dart';
import 'package:runmate_app/presentation/running_info/running_info_page.dart';
import 'package:runmate_app/presentation/running_monitor/pages/running_monitor_page.dart';
import 'package:runmate_app/presentation/running/running_page.dart';
import 'package:runmate_app/presentation/user_profile/user_profile_page.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';

class Routes {
  static List<GetPage> pages = [
    GetPage(
      name: Paths.loginPage,
      page: () => const LoginPage(),
      binding: LoginModule(),
    ),
    GetPage(
      name: Paths.menuPage,
      page: () => const MenuPage(),
      binding: MenuModule(),
    ),
    GetPage(
      name: Paths.runningMonitor,
      page: () => const RunningMonitorPage(),
      binding: RunningMonitorModule(),
    ),
    GetPage(name: Paths.challengesPage, page: () => const ChallengesPage(), binding: ChallengesModule()),
    GetPage(name: Paths.challengePage, page: () => const ChallengePage(), binding: ChallengeModule()),
    GetPage(
        name: Paths.chatPage,
        page: () => const ChatPage(),
        binding: ChatModule(),),
    GetPage(name: Paths.newGoal, page: () => const NewGoalPage()),
    GetPage(name: Paths.newChallenge, page: () => const NewChallengePage(), binding: NewChallengeModule()),
    GetPage(
      name: Paths.running,
      page: () => const RunningPage(),
      binding: RunningModule(),
    ),
    GetPage(
      name: Paths.runningInfo,
      page: () => const RunningInfoPage(),
      binding: RunningInfoModule(),
    ),
    GetPage(
      name: Paths.registerPage,
      page: () => const RegisterPage(),
      binding: RegisterModule(),
    ),
    GetPage(
      name: Paths.friendsPage,
      page: () => const FriendsPage(),
      binding: FriendsModule(),
    ),
    GetPage(
      name: Paths.userProfile,
      page: () => const UserProfilePage(),
      binding: UserProfileModule(),
    ),
    GetPage(
      name: Paths.post,
      page: () => const PostPage(),
      binding: PostModule(),
    ),
  ];
}
