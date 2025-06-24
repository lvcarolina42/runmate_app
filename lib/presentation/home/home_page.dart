import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/presentation/home/controller/home_controller.dart';
import 'package:runmate_app/presentation/widgets/post_item.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';

// Funções auxiliares movidas para o escopo do arquivo para serem usadas no Card
String _formatDate(DateTime date) {
  return DateFormat('dd/MM/yy').format(date);
}

String _remainingDays(DateTime start, DateTime end) {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final HomeController _controller = Get.find<HomeController>();

  Widget? _focusedPost;
  bool _showOverlay = false;

  void _showFocusedPost(Widget post) {
    setState(() {
      _focusedPost = post;
      _showOverlay = true;
    });
  }

  void _hideFocusedPost() {
    setState(() {
      _showOverlay = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!_showOverlay) {
        setState(() {
          _focusedPost = null;
        });
      }
    });
  }

  String get name {
    final List<String> names = _controller.user?.name.split(' ') ?? [];
    if (names.length > 1) {
      return '${names.first} ${names.last}';
    }
    return names.firstOrNull ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue950,
      body: SafeArea(
        child: Stack(
          children: [
            Observer(
              builder: (context) {
                return RefreshIndicator.adaptive(
                  onRefresh: _controller.onInitialize,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    children: [
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Olá, $name!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.poppinsRegular,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('Desafios',
                                    style: TextStyle(color: Colors.white)),
                                const SizedBox(width: 8.0),
                                if (_controller.challenges.isNotEmpty)
                                  CircleAvatar(
                                    radius: 12.0,
                                    backgroundColor: AppColors.blue700,
                                    child: Text(
                                      _controller.challenges.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    ),
                                  ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Paths.challengesPage);
                              },
                              child: const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      SizedBox(
                        height: 155, // Altura ajustada para caber mais informações
                        child: _controller.challenges.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Center(
                                  child: Text(
                                    'Você não está em nenhum desafio.',
                                    style: TextStyle(color: AppColors.blue200),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: _controller.challenges.length,
                                itemBuilder: (context, index) {
                                  final challenge = _controller.challenges[index];
                                  return _ChallengeCard(
                                    challenge: challenge,
                                    userDistance: _controller.userDistance(challenge),
                                  );
                                },
                              ),
                      ),
                      if (!GetPlatform.isWeb) ...[
                          const SizedBox(height: 24.0),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Publicações',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: AppFonts.poppinsMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ..._controller.runs.map((run) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: GestureDetector(
                              onTap: () => Get.toNamed(Paths.post, arguments: run),
                              onLongPress: () => _showFocusedPost(SizedBox(width: 300, height: 360, child: PostItem(run: run))),
                              child: PostItem(run: run),
                            ),
                          )),
                        ],
                      const SizedBox(height: 64.0),
                    ],
                  ),
                );
              }
            ),
            if (_focusedPost != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideFocusedPost,
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(color: Colors.black.withOpacity(0.5)),
                      ),
                      Center(
                        child: AnimatedOpacity(
                          opacity: _showOverlay ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedScale(
                            scale: _showOverlay ? 1.0 : 0.95,
                            duration: const Duration(milliseconds: 200),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 16.0,
                              borderRadius: BorderRadius.circular(16.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: _focusedPost!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET DO CARD DE DESAFIO ATUALIZADO ---
class _ChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final int userDistance;

  const _ChallengeCard({
    required this.challenge,
    required this.userDistance,
  });

  double _calculateProgress() {
    final bool isDistanceType = challenge.type.name == 'distance';
    if (isDistanceType) {
      if (challenge.distance == null || challenge.distance == 0) return 0;
      return (userDistance / challenge.distance!).clamp(0.0, 1.0);
    } else {
      final now = DateTime.now();
      if (now.isBefore(challenge.startDate)) return 0;
      if (now.isAfter(challenge.endDate)) return 1;
      final total = challenge.endDate.difference(challenge.startDate).inSeconds;
      final passed = now.difference(challenge.startDate).inSeconds;
      return (passed / total).clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDistanceType = challenge.type.name == 'distance';
    final progress = _calculateProgress();
    
    String statusText;
    Color statusColor;

    if (challenge.isFinished == true) {
      statusText = 'Finalizado';
      statusColor = Colors.green[600]!;
    } else if (DateTime.now().isBefore(challenge.startDate)) {
      statusText = 'Não iniciado';
      statusColor = AppColors.blue700;
    } else {
      statusText = 'Em andamento';
      statusColor = AppColors.blue700;
    }

    final String progressFooterText = isDistanceType
        ? "${userDistance}m / ${challenge.distance}m"
        : _remainingDays(challenge.startDate, challenge.endDate);

    return GestureDetector(
      onTap: () {
        Get.toNamed(Paths.challengePage, arguments: challenge.id);
      },
      child: Container(
        width: 220, // Largura ajustada para mais informações
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.gray800,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha 1: Título e Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.poppinsSemiBold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(fontSize: 9, fontFamily: AppFonts.poppinsMedium),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Linha 2: Datas
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.blue300, size: 12),
                const SizedBox(width: 4),
                Text(
                  isDistanceType
                      ? 'Início em ${_formatDate(challenge.startDate)}'
                      : '${_formatDate(challenge.startDate)} - ${_formatDate(challenge.endDate)}',
                  style: const TextStyle(
                    color: AppColors.blue300,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            if (isDistanceType) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.flag, color: AppColors.blue300, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    '${challenge.distance} metros',
                    style: const TextStyle(color: AppColors.blue300, fontSize: 10),
                  ),
                ],
              ),
            ],

            const Spacer(),

            // Linha 3: Progresso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.gray700,
                    color: AppColors.orange500,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    progressFooterText,
                    style: const TextStyle(
                      color: AppColors.blue300,
                      fontSize: 10,
                      fontFamily: AppFonts.poppinsRegular,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
