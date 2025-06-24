import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/presentation/friends/controller/friends_controller.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/search_input.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';


class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  // Use 'Get.put' para injetar o controller se ele não for injetado globalmente
  final FriendsController _friendsController = Get.find<FriendsController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = GetPlatform.isWeb;
    return Scaffold(
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.blue950,
        elevation: 0,
        title: const Text(
          'Amigos',
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.poppinsMedium,
            fontSize: 18.0,
          ),
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.orange500,
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontFamily: AppFonts.poppinsMedium,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Amigos'),
            Tab(text: 'Explorar'),
          ],
        ),
      ),
      body: Observer(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 16),
            child: TabBarView(
                controller: _tabController,
                children: [
                  // Aba 1: Meus Amigos
                  _UserListContent(
                    users: _friendsController.users,
                    searchController: _friendsController.searchController,
                    onFollow: (user) => _friendsController.removeFriend(user.id),
                    isExplorerTab: false,
                  ),
                  // Aba 2: Explorar
                  _UserListContent(
                    users: _friendsController.usersAll,
                    searchController: _friendsController.searchControllerAll,
                    onFollow: (user) => _friendsController.addFriend(user.id),
                    isExplorerTab: true,
                  ),
                ],
              ),
          );
        }
      ),
    );
  }
}

class _UserListContent extends StatelessWidget {
  final List<User> users;
  final TextEditingController searchController;
  final Function(User) onFollow;
  final bool isExplorerTab;

  const _UserListContent({
    required this.users,
    required this.searchController,
    required this.onFollow,
    required this.isExplorerTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          SearchInput(controller: searchController),
          const SizedBox(height: 12),
          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Text(
                      isExplorerTab
                          ? 'Nenhum usuário encontrado.'
                          : 'Você ainda não segue ninguém.',
                      style: const TextStyle(
                        color: AppColors.blue200,
                        fontFamily: AppFonts.poppinsRegular,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 64),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _UserListItem(
                        user: user,
                        onFollow: () => onFollow(user),
                        isExplorerTab: isExplorerTab,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onFollow;
  final bool isExplorerTab;

  const _UserListItem({
    required this.user,
    required this.onFollow,
    required this.isExplorerTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed(Paths.userProfile, arguments: user),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/600?u=${user.id}',
              ),
              radius: 24.0,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.poppinsSemiBold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    user.username,
                    style: const TextStyle(
                      color: AppColors.blue300,
                      fontFamily: AppFonts.poppinsRegular,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                isExplorerTab ? 'Seguir' : 'Seguindo',),
            ),
          ],
        ),
      ),
    );
  }
}
