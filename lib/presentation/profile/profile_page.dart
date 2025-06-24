import 'dart:math'; // Adicionado para usar a função min()
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/presentation/widgets/post_item.dart';
import 'package:runmate_app/presentation/profile/controller/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.find<ProfileController>();
  
  Goal? _currentUserGoal;

  Goal? _goal;

  @override
  void initState() {
    super.initState();
    _currentUserGoal = controller.user?.goal;

    if (_currentUserGoal?.dailyDistanceInMeters != 0 && _currentUserGoal?.daysPerWeek != 0) {
      _goal = _currentUserGoal;
    } else {
      _goal = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = GetPlatform.isWeb;
    return Scaffold(
      backgroundColor: AppColors.blue950,
      body: Observer(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () => controller.onInitialize(),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Paths.friendsPage),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray800,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Row(
                        children: [
                          Text('Amigos', style: TextStyle(color: Colors.white)),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
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
                        value: '${controller.getAvaragePace()}/km',
                      ),
                      _buildGridItem(
                        icon: Icons.run_circle_outlined,
                        iconColor: Colors.orangeAccent,
                        title: 'Melhor pace',
                        value: '${controller.bestPace()}/km',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildXpCard(),
                const SizedBox(height: 16.0),
                _buildWeeklyGoalChart(),
                if (!isWeb) ...[
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
                    ...controller.runs.map((run) => GestureDetector(
                      onTap: () => Get.toNamed(Paths.post, arguments: run),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    );
  }

  /// Decide se mostra o gráfico ou o botão para criar uma meta.
  Widget _buildWeeklyGoalChart() {
    if (_goal != null) {
      return _buildGoalChartWidget(
        runs: controller.runs,
        goal: _goal!,
      );
    } else {
      return _buildCreateGoalButton();
    }
  }

  /// Botão que abre o dialog para criar uma nova meta.
  Widget _buildCreateGoalButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () => _showGoalDialog(),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.gray800,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.orange500),
              SizedBox(width: 8),
              Text(
                'Criar meta semanal',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card que exibe o gráfico de progresso semanal.
  Widget _buildGoalChartWidget({required List<Run> runs, required Goal goal}) {
    final weeklyDistances = goal.weeklyDistancesInMeters;
    final progress = _calculateWeeklyProgress(weeklyDistances, goal);
    final dailyGoalMeters = goal.dailyDistanceInMeters!;

    // Defina o valor máximo para o eixo Y do gráfico.
    // Se a meta for 0, usamos um valor padrão para evitar divisão por zero.
    final chartMaxY = dailyGoalMeters > 0 ? dailyGoalMeters * 1.5 : 1000.0;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progresso na meta',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        text: '${progress['completed']}',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: ' / ${progress['target']} dias',
                            style: const TextStyle(
                              color: AppColors.blue200,
                              fontFamily: AppFonts.poppinsRegular,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showGoalDialog(goal: _goal),
                  icon: const Icon(Icons.edit, color: AppColors.blue200, size: 20),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (dailyGoalMeters > 0)
                        HorizontalLine(
                          y: dailyGoalMeters.toDouble(),
                          color: AppColors.orange500.withOpacity(0.8),
                          strokeWidth: 2,
                          dashArray: [8, 4],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(right: 5, bottom: 2),
                            style: const TextStyle(color: AppColors.orange500, fontSize: 10),
                            labelResolver: (line) => '${line.y.toInt()} m',
                          ),
                        ),
                    ],
                  ),
                  maxY: chartMaxY,
                  alignment: BarChartAlignment.spaceAround,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: _bottomTitles,
                      ),
                    ),
                  ),
                  barGroups: weeklyDistances.asMap().entries.map((entry) {
                    final index = entry.key;
                    final distanceInMeters = entry.value;
                    
                    // --- ALTERAÇÃO PRINCIPAL AQUI ---
                    // A altura da barra (toY) é o menor valor entre a distância real e o topo do gráfico.
                    final barHeight = min(distanceInMeters, chartMaxY);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: barHeight.toDouble(),
                          // A cor continua baseada na distância real, não na altura da barra.
                          color: dailyGoalMeters > 0 && distanceInMeters >= dailyGoalMeters
                              ? Colors.tealAccent
                              : AppColors.blue300,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra o dialog (Bottom Sheet) para criar/editar a meta.
  Future<void> _showGoalDialog({Goal? goal}) async {
    final isEditing = goal != null && goal.dailyDistanceInMeters != null && goal.daysPerWeek != null;
    final distanceController = TextEditingController(
      text: isEditing ? (goal.dailyDistanceInMeters! / 1000).toStringAsFixed(1).replaceAll('.0', '') : '',
    );
    final selectedDays = (isEditing ? goal.daysPerWeek : 3).obs;

    final result = await Get.bottomSheet<bool?>(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          decoration: const BoxDecoration(
            color: AppColors.gray800,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.gray700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                isEditing ? 'Editar Meta Semanal' : 'Nova Meta Semanal',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: AppFonts.poppinsSemiBold,
                ),
              ),
              const SizedBox(height: 24),
              const Text("Distância por dia", style: TextStyle(color: AppColors.blue200, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: distanceController,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.gray700,
                  hintText: 'Ex: 5',
                  hintStyle: const TextStyle(color: AppColors.gray500),
                  suffixText: 'km',
                  suffixStyle: const TextStyle(color: AppColors.blue200, fontSize: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Frequência na semana", style: TextStyle(color: AppColors.blue200, fontSize: 14)),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<int>(
                value: selectedDays.value,
                items: List.generate(7, (index) => index + 1)
                    .map((d) => DropdownMenuItem(value: d, child: Text('$d ${d > 1 ? 'dias' : 'dia'}')))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedDays.value = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.gray700,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                dropdownColor: AppColors.gray700,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                iconEnabledColor: AppColors.orange500,
              )),
              const SizedBox(height: 32),
              Row(
                children: [
                  if (isEditing)
                    TextButton(
                      onPressed: () {
                        controller.deleteGoal();
                        _goal = null;
                        Get.back(result: true);
                      },
                      child: const Text('REMOVER META', style: TextStyle(color: Colors.redAccent)),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange500,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      var distanceText = distanceController.text.trim();
                      if (distanceText.isEmpty) return;

                      distanceText = distanceText.replaceAll(',', '.');
                      final distance = double.tryParse(distanceText);
                      if (distance == null) return;
                      final goal = Goal(dailyDistanceInMeters: (distance * 1000).toInt(), daysPerWeek: selectedDays.value, weeklyDistances: _goal?.weeklyDistances);
                      _goal = goal;
                      await controller.addGoal(days: goal.daysPerWeek!, distance: goal.dailyDistanceInMeters!);
                      Get.back(result: true);
                    },
                    child: const Text(
                      'SALVAR META',
                      style: TextStyle(fontFamily: AppFonts.poppinsSemiBold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );

    if (result == true) {
      await controller.onInitialize();
    }
  }

  /// Calcula quantos dias da semana a meta foi atingida.
  Map<String, int> _calculateWeeklyProgress(List<int> weeklyDistancesInMeters, Goal goal) {
    int daysCompleted = 0;
    final dailyGoalMeters = goal.dailyDistanceInMeters;

    if (dailyGoalMeters! <= 0) return {'completed': 0, 'target': goal.daysPerWeek!};

    for (final distance in weeklyDistancesInMeters) {
      if (distance >= dailyGoalMeters) {
        daysCompleted++;
      }
    }
    return {'completed': daysCompleted, 'target': goal.daysPerWeek!};
  }

  /// Prepara os dados das corridas retornando uma lista de distâncias em METROS.
  // List<double> _prepareChartData(List<Run> runs) {
  //   final List<double> weeklyDistances = List.filled(7, 0.0);
  //   final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //   final lastSunday = now.subtract(Duration(days: now.weekday % 7));
  //   final startOfWeek = DateUtils.dateOnly(lastSunday);

  //   for (final run in runs) {
  //     final runDate = DateUtils.dateOnly(run.date);
  //     if (!runDate.isBefore(startOfWeek) && runDate.isBefore(startOfWeek.add(const Duration(days: 7)))) {
  //       int dayIndex = run.date.weekday % 7;
  //       weeklyDistances[dayIndex] += run.distance;
  //     }
  //   }
  //   return [
  //     40, 10, 30, 0, 0, 40, 20
  //   ];
  // }

  /// Retorna os widgets para os títulos do eixo X (dias da semana).
  Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: AppColors.blue200, fontSize: 12, fontFamily: AppFonts.poppinsRegular);
    String text;
    switch (value.toInt()) {
      case 0: text = 'D'; break;
      case 1: text = 'S'; break;
      case 2: text = 'T'; break;
      case 3: text = 'Q'; break;
      case 4: text = 'Q'; break;
      case 5: text = 'S'; break;
      case 6: text = 'S'; break;
      default: text = '';
    }
    return SideTitleWidget(
      meta: meta,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  // --- WIDGETS EXISTENTES ---
  Widget _buildXpCard() {
    final user = SessionManager().currentUser;
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
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: AppFonts.poppinsMedium),
                ),
                const Text(
                  'Próximo Nível',
                  style: TextStyle(color: AppColors.blue200, fontSize: 12, fontFamily: AppFonts.poppinsRegular),
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
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.orange500),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${user.xp} / ${user.nextLevelXp + user.xp} XP',
                style: const TextStyle(color: AppColors.blue200, fontSize: 12, fontFamily: AppFonts.poppinsRegular),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({required IconData icon, required Color iconColor, required String title, required String value}) {
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
            style: const TextStyle(color: AppColors.blue200, fontSize: 12, fontFamily: AppFonts.poppinsRegular),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: iconColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppFonts.poppinsMedium),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String get name {
    final List<String> names = SessionManager().currentUser?.name.split(' ') ?? [];
    if (names.length > 1) {
      return '${names.first} ${names.last}';
    }
    return names.firstOrNull ?? '';
  }

  Widget _buildHeader() {
    final user = SessionManager().currentUser;
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
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "@${user.username}",
                  style: const TextStyle(color: AppColors.blue300, fontSize: 16),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/600?u=${user.id}'),
            radius: 32.0,
          ),
        ],
      ),
    );
  }
}