import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/presentation/challenge/controller/challenge_controller.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final ChallengeController _challengeController = Get.find<ChallengeController>();

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  double calculateProgressByDate(DateTime start, DateTime end) {
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
      if (diff.inDays == 1) {
        return 'Inicia em ${diff.inDays} dia';
      } else if (diff.inDays > 1) {
        return 'Inicia em ${diff.inDays} dias';
      } else {
        return 'Inicia em menos de 1 dia';
      }
    }

    final difference = end.difference(now);

    if (difference.inSeconds <= 0) {
      return 'Finalizado';
    } else if (difference.inDays >= 1) {
      return 'Faltam ${difference.inDays} dias';
    } else {
      return 'Falta menos de 1 dia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Observer(
      builder: (context) {
        final challenge = _challengeController.challenge;
        final bool isDistance = challenge.type.name == 'distance';

        final progress = isDistance
            ? calculateProgressDistance(challenge.distance ?? 0, _challengeController.userDistance())
            : calculateProgressByDate(challenge.startDate, challenge.endDate);

        final daysRemaining = isDistance ? '' : remainingDays(challenge.startDate, challenge.endDate);
        final String distanceDescription = isDistance ? "${_challengeController.userDistance()}/${challenge.distance}m" : '';
        
        return Scaffold(
          backgroundColor: AppColors.blue950,
          appBar: AppBar(
            backgroundColor: AppColors.blue950,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Detalhes do Desafio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: AppFonts.poppinsMedium,
              ),
            ),
            leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 480 : 16, vertical: 16),
            child: Observer(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Text(
                      challenge.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: AppFonts.poppinsSemiBold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      challenge.description,
                      style: const TextStyle(
                        color: AppColors.blue300,
                        fontSize: 14,
                        fontFamily: AppFonts.poppinsRegular,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: challenge.isFinished == true ? Colors.green : AppColors.blue700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            challenge.isFinished == true ? 'Finalizado' : 'Em andamento',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: AppFonts.poppinsMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.blue700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isDistance ? 'Distância' : 'Período',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: AppFonts.poppinsMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                        
                    const SizedBox(height: 16),
                        
                    /// Informações principais
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.blue300, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          isDistance
                              ? 'Início em ${formatDate(challenge.startDate)}'
                              : '${formatDate(challenge.startDate)} até ${formatDate(challenge.endDate)}',
                          style: const TextStyle(
                            color: AppColors.blue300,
                            fontSize: 12,
                            fontFamily: AppFonts.poppinsRegular,
                          ),
                        ),
                      ],
                    ),
                        
                    if (isDistance) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.flag, color: AppColors.blue300, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${challenge.distance} metros',
                            style: const TextStyle(
                              color: AppColors.blue300,
                              fontSize: 12,
                              fontFamily: AppFonts.poppinsRegular,
                            ),
                          ),
                        ],
                      ),
                    ],
                        
                    const SizedBox(height: 24),
                        
                    /// Barra de progresso
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: AppColors.gray700,
                        color: AppColors.orange500,
                        minHeight: 10,
                      ),
                    ),
                        
                    const SizedBox(height: 6),
                        
                    if (!isDistance)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          daysRemaining,
                          style: const TextStyle(
                            color: AppColors.blue300,
                            fontSize: 12,
                            fontFamily: AppFonts.poppinsRegular,
                          ),
                        ),
                      ),

                    if (isDistance) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          distanceDescription,
                          style: const TextStyle(
                            color: AppColors.blue300,
                            fontSize: 12,
                            fontFamily: AppFonts.poppinsRegular,
                          ),
                        ),
                      ),
                    ],
                        
                    const SizedBox(height: 24),
                        
                    const Text(
                      'Ranking',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: AppFonts.poppinsSemiBold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._challengeController.challenge.ranking.map((e) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(Paths.userProfile, arguments: e.user),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.gray800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${e.position + 1}º',
                                style: const TextStyle(
                                  color: AppColors.orange500,
                                  fontFamily: AppFonts.poppinsSemiBold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/600?u=${e.user.id}',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                e.user.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: AppFonts.poppinsRegular,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${e.distance} metros',
                                style: const TextStyle(
                                  color: AppColors.blue300,
                                  fontSize: 12,
                                  fontFamily: AppFonts.poppinsRegular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }
            ),
          ),
        
          /// Botão flutuante para abrir o chat
          floatingActionButton: isWeb ? null : FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: AppColors.orange500,
            onPressed: () {
              Get.toNamed(Paths.chatPage, arguments: challenge.id);
            },
            child: const Icon(Icons.chat, color: Colors.white),
          ),
        );
      }
    );
  }
}
