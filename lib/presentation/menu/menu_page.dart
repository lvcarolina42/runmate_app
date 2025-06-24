import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/presentation/events/events_page.dart';
import 'package:runmate_app/presentation/weather_information/weather_information_page.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/presentation/home/home_page.dart';
import 'package:runmate_app/presentation/profile/profile_page.dart';
import 'package:runmate_app/presentation/runner_stats/runner_stats.dart';
import 'package:runmate_app/presentation/menu/controller/menu_controller.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _controller = Get.find<MenuPageController>();

  void _onItemTapped(int index) {
    setState(() {
      _controller.onChangePage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = GetPlatform.isWeb;
    return Scaffold(
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        backgroundColor: AppColors.blue950,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.blue950,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Cabeçalho com Avatar e Infos
              Container(
                padding: const EdgeInsets.only(top: 64, bottom: 24, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: AppColors.blue900,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/600?u=${SessionManager().currentUser?.id}',
                      ),
                      radius: 30.0,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SessionManager().currentUser!.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.blue200,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppFonts.poppinsMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Nível 01',
                            style: TextStyle(
                              color: AppColors.blue600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.poppinsRegular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Itens do menu
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 8),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings, color: AppColors.blue200),
                      title: const Text(
                        'Configurações',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _controller.onChangePage(2);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.sunny, color: AppColors.blue200),
                      title: const Text(
                        'Clima',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _controller.onChangePage(3);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person, color: AppColors.blue200),
                      title: const Text(
                        'Perfil',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _controller.onChangePage(4);
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(color: AppColors.gray800, thickness: 1, indent: 12, endIndent: 12),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () {
                        _controller.logout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: PageView(
        controller: _controller.controllerPage,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 0),
            child: const HomePage(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 0),
            child: const EventsPage(),
          ),
          const Center(
            child: Text(
              'Configurações',
              style: TextStyle(
                  color: Colors.white, fontFamily: AppFonts.poppinsMedium),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 0),
            child: const WeatherInformationPage(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 0),
            child: const ProfilePage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.gray800,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue900,
                    ),
              child: const Icon(
                Icons.directions_run,
                size: 36,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _controller.currentIndex,
        selectedItemColor: AppColors.orange600,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[700],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      SessionManager().currentUser!.username,
                      style: const TextStyle(
                          color: AppColors.blue200,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Nível 01',
                      style: TextStyle(
                          color: AppColors.blue600,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
