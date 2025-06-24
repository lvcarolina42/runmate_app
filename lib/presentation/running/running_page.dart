import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:runmate_app/presentation/running/controller/running_controller.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_text_themes.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({super.key});

  @override
  State<RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  final RunningController controller = Get.find<RunningController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Observer(
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue950, AppColors.blue800],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cabeçalho com tempo decorrido
                  Column(
                    children: [
                      Text(
                        controller.formatDuration(controller.elapsedTime),
                        style: titleLgMedium.customColor(AppColors.whiteBrand),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tempo de atividade",
                        style: subtitleSmRegular.customColor(AppColors.blue100),
                      ),
                    ],
                  ),
            
                  // Cards de dados
                  Column(
                    children: [
                      _DataCard(
                        label: "Distância",
                        value: controller.distanceInKm,
                        icon: Icons.map,
                      ),
                      const SizedBox(height: 12),
                      _DataCard(
                        label: "Ritmo",
                        value: controller.pace,
                        icon: Icons.timer,
                      ),
                      const SizedBox(height: 12),
                      _DataCard(
                        label: "Velocidade média",
                        value: controller.averageSpeed,
                        icon: Icons.speed,
                      ),
                    ],
                  ),
            
                  // Botão finalizar
                  ElevatedButton.icon(
                    onPressed: () => controller.stopTracking(),
                    icon: const Icon(Icons.stop, color: AppColors.whiteBrand),
                    label: Text("Finalizar Corrida", style: subtitleLgMedium.customColor(AppColors.whiteBrand)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange500,
                      foregroundColor: AppColors.blue950,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DataCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.blue700.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.orange300, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: titleLgSemiBold.customColor(AppColors.whiteBrand),
              ),
              Text(
                label,
                style: bodySmRegular.customColor(AppColors.blue100),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
