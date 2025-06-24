import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/presentation/challenges/controller/challenges_controller.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/search_input.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

// 1. Adicionado SingleTickerProviderStateMixin para o TabController
class _ChallengesPageState extends State<ChallengesPage>
    with SingleTickerProviderStateMixin {
  final ChallengesController _challengesController = Get.find<ChallengesController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2. Inicializa o TabController com duas abas
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
          'Desafios',
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
        // 3. Adiciona a TabBar na parte inferior da AppBar
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.orange500, // Cor do indicador
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontFamily: AppFonts.poppinsMedium,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Meus desafios'),
            Tab(text: 'Explorar'),
          ],
        ),
      ),
      // 4. O corpo agora é um TabBarView
      body: Observer(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 16),
            child: TabBarView(
              controller: _tabController,
              children: [
                // Aba 1: Meus desafios
                _ChallengesContent(
                  isMyChallenges: true,
                  onInialize: _challengesController.onInialize,
                  challenges: _challengesController.challenges,
                  controller: _challengesController.searchController,
                  joinChallenge: _challengesController.joinChallenge,
                  userDistance: _challengesController.userDistance,
                ),
                // Aba 2: Explorar (usando o mesmo conteúdo por enquanto)
                _ChallengesContent(
                  isMyChallenges: false,
                  onInialize: _challengesController.onInialize,
                  challenges: _challengesController.challengesAll,
                  userDistance: _challengesController.userDistance,
                  joinChallenge: _challengesController.joinChallenge,
                  controller: _challengesController.searchControllerAll,
                ),
              ],
            ),
          );
        }
      ),
      floatingActionButton: isWeb ? null : FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.orange500,
        onPressed: () {
          Get.toNamed(Paths.newChallenge);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// 5. Widget reutilizável para o conteúdo de cada aba
class _ChallengesContent extends StatelessWidget {
  final bool isMyChallenges;
  final VoidCallback onInialize;
  final Function(String) joinChallenge;
  final TextEditingController controller;
  final List<ChallengeModel> challenges;
  final Function(ChallengeModel) userDistance;

  const _ChallengesContent({
    required this.controller,
    required this.onInialize,
    required this.challenges,
    required this.userDistance,
    required this.joinChallenge,
    required this.isMyChallenges,
  });

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  double calculateProgress(DateTime start, DateTime end) {
    final now = DateTime.now();
    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return 1;
    final total = end.difference(start).inSeconds;
    final passed = now.difference(start).inSeconds;
    return passed / total;
  }

  double calculateProgressDistance(int totalDistance, int userDistance) {
    if (totalDistance == 0) return 0;
    return userDistance / totalDistance;
  }

  String remainingDays(DateTime start, DateTime end) {
    final now = DateTime.now();
    if (now.isBefore(start)) {
      final diff = start.difference(now);
      if (diff.inDays >= 1) return 'Inicia em ${diff.inDays}d';
      return 'Inicia hoje';
    }
    final difference = end.difference(now);
    if (difference.isNegative) return 'Finalizado';
    if (difference.inDays >= 1) return 'Faltam ${difference.inDays}d';
    return 'Acaba hoje';
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              SearchInput(controller: controller),
              const SizedBox(height: 12),
              Expanded(
                child: challenges.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum desafio encontrado',
                          style: TextStyle(
                            color: AppColors.blue200,
                          ),
                        ),
                      )
                    : RefreshIndicator.adaptive(
                        onRefresh: () {
                          onInialize();
                          return Future.delayed(const Duration(microseconds: 1));
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 64),
                          itemCount: challenges.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = challenges[index];
                            final bool isDistance = item.type.name == 'distance';
                            final double progress = isDistance
                                ? calculateProgressDistance(
                                    item.distance!, userDistance(item))
                                : calculateProgress(item.startDate, item.endDate);
                            final String daysRemainingText =
                                isDistance ? '' : remainingDays(item.startDate, item.endDate);
                            final String distanceDescription = isDistance
                                ? "${userDistance(item)}/${item.distance}m"
                                : '';
                            return GestureDetector(
                              onTap: () => Get.toNamed(
                                Paths.challengePage,
                                arguments: item.id,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.gray800,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: AppFonts.poppinsSemiBold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: item.isFinished == true
                                                ? Colors.green[600]
                                                : AppColors.blue700,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            item.isFinished == true
                                                ? 'Finalizado'
                                                : DateTime.now()
                                                        .isBefore(item.startDate)
                                                    ? 'Não iniciado'
                                                    : 'Em andamento',
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            color: AppColors.blue300, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          isDistance
                                              ? 'Início em ${formatDate(item.startDate)}'
                                              : '${formatDate(item.startDate)} até ${formatDate(item.endDate)}',
                                          style: const TextStyle(
                                            color: AppColors.blue300,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.blue700,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            isDistance ? 'Distância' : 'Período',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isDistance) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.flag,
                                              color: AppColors.blue300, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.distance} metros',
                                            style: const TextStyle(
                                              color: AppColors.blue300,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (isMyChallenges) ...[
                                      const SizedBox(height: 16),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          backgroundColor: AppColors.gray700,
                                          color: AppColors.orange500,
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          isDistance ? distanceDescription : daysRemainingText,
                                          style: const TextStyle(
                                            color: AppColors.blue300,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (!isMyChallenges &&
                                        item.isFinished != true) ...[
                                      const SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.login,
                                              size: 16),
                                          label:
                                              const Text('Entrar no desafio'),
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .orange500
                                                .withOpacity(0.8),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12),
                                            ),
                                          ),
                                          onPressed: () {
                                            joinChallenge(item.id);
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
