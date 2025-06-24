import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // Import for MobX Observer
import 'package:get/get.dart';
import 'package:runmate_app/domain/user/model/user.dart'; // Assuming this is your User model
import 'package:runmate_app/presentation/user_profile/controller/user_profile_controller.dart';
import 'package:runmate_app/presentation/widgets/post_item.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserProfileController controller = Get.find<UserProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        backgroundColor: AppColors.blue950,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Observer(
          builder: (_) {
            // Display the viewed user's name in the AppBar
            return Text(
              controller.user?.name ?? 'Perfil do Usuário',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: AppFonts.poppinsMedium,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Observer(
        builder: (context) {
          final user = controller.user;
          // Show a loading indicator if user data is not yet available
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 800 ? 480 : 0),
            children: [
              const SizedBox(height: 16),
              _buildHeader(user: user),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.5,
                  children: [
                    _buildGridItem(
                      icon: Icons.speed,
                      iconColor: Colors.tealAccent,
                      title: 'Pace Médio',
                      value: "${controller.getAvaragePace()}/km"
                    ),
                    _buildGridItem(
                      icon: Icons.run_circle_outlined,
                      iconColor: Colors.orangeAccent,
                      title: 'Melhor pace',
                      value: "${controller.bestPace()}/km"
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // XP Card using the fetched user's data
              _buildXpCard(user: user),
              if (!GetPlatform.isWeb) ...[
                  const SizedBox(height: 24.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Últimas Corridas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: AppFonts.poppinsMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // Display runs, assuming controller.runs will be updated for the viewed user
                  ...controller.runs
                      .map((run) => GestureDetector(
                        onTap: () => Get.toNamed(Paths.post, arguments: run),
                        child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: PostItem(run: run),
                            ),
                      )),
                ],
              const SizedBox(height: 64.0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildXpCard({required User? user}) {
    if (user == null) return const SizedBox.shrink();

    final double progress = (user.xp / (user.nextLevelXp + user.xp)).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${user.level}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: AppFonts.poppinsMedium,
                  ),
                ),
                const Text(
                  'Próximo Nível',
                  style: TextStyle(
                    color: AppColors.blue200,
                    fontSize: 12,
                    fontFamily: AppFonts.poppinsRegular,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.gray700,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.orange500),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${user.xp} / ${user.nextLevelXp + user.xp} XP',
                style: const TextStyle(
                  color: AppColors.blue200,
                  fontSize: 12,
                  fontFamily: AppFonts.poppinsRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.blue200,
              fontSize: 12,
              fontFamily: AppFonts.poppinsRegular,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: iconColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.poppinsMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getDisplayName({required User? user}) {
    final List<String> names = user?.name.split(' ') ?? [];
    if (names.length > 1) {
      return '${names.first} ${names.last}';
    }
    return names.firstOrNull ?? '';
  }

  Widget _buildHeader({required User? user}) {
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDisplayName(user: user),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "@${user.username}",
                  style: const TextStyle(
                    color: AppColors.blue300,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/600?u=${user.id}',
            ),
            radius: 32.0,
          ),
        ],
      ),
    );
  }
}