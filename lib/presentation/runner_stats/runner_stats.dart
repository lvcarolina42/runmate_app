import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';

class RunnerStatsPage extends StatefulWidget {
  const RunnerStatsPage({super.key});

  @override
  State<RunnerStatsPage> createState() => _RunnerStatsPageState();
}

class _RunnerStatsPageState extends State<RunnerStatsPage>
    with TickerProviderStateMixin {
  final List<String> weekDays = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  final List<List<double>> weekData = [
    [3.0, 6.1, 2.5, 0.0, 4.4, 5.2, 1.8],
    [5.2, 7.0, 4.5, 10.0, 0.0, 8.3, 6.7],
  ];

  int currentWeekIndex = 1;
  bool _hasAnimated = false;

  List<AnimationController> controllers = [];
  List<Animation<double>> animations = [];

  List<double> get displayedKm => weekData[currentWeekIndex];

  double get totalKm =>
      displayedKm.fold(0.0, (prev, element) => prev + element);

  String get weekLabel =>
      currentWeekIndex == 1 ? 'Semana atual' : 'Semana passada';

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    for (int i = 0; i < displayedKm.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      final animation = Tween<double>(begin: 0, end: displayedKm[i])
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      controllers.add(controller);
      animations.add(animation);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      for (final c in controllers) {
        c.forward();
      }
      _hasAnimated = true;
    });
  }

  void previousWeek() {
    setState(() {
      if (currentWeekIndex > 0) currentWeekIndex--;
    });
  }

  void nextWeek() {
    setState(() {
      if (currentWeekIndex < weekData.length - 1) currentWeekIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue950,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '43,75 KM',
                        style: TextStyle(
                          color: AppColors.blue100,
                          fontFamily: AppFonts.poppinsSemiBold,
                          fontSize: 40,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.arrow_upward,
                              color: Colors.green, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '2.3% a mais que semana passada',
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: AppFonts.poppinsSemiBold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildBarChart(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Suas metas',
                    style: TextStyle(
                      color: AppColors.blue100,
                      fontFamily: AppFonts.poppinsSemiBold,
                      fontSize: 32.0,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(Paths.newGoal);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.blue100,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              ..._buildGoalsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 250,
      child: AnimatedBuilder(
        animation: Listenable.merge(controllers),
        builder: (context, _) {
          return BarChart(
            BarChartData(
              maxY: 12,
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38,
                    getTitlesWidget: (value, _) {
                      final int index = value.toInt();
                      if (index >= 0 && index < weekDays.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            weekDays[index],
                            style: const TextStyle(color: AppColors.blue100),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              barGroups: List.generate(displayedKm.length, (index) {
                final toY =
                    _hasAnimated ? animations[index].value : displayedKm[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: toY,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      width: 20,
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGoalsList() {
    final List<Map<String, dynamic>> mockGoals = [
      {
        'icon': Icons.directions_run,
        'title': 'Correr 50 km este mês',
        'date': 'Até 30/05',
        'progress': 0.75,
      },
      {
        'icon': Icons.speed,
        'title': 'Manter pace abaixo de 5\'30"/km',
        'date': 'Até 15/06',
        'progress': 0.4,
      },
      {
        'icon': Icons.timer,
        'title': 'Correr por 2h seguidas',
        'date': 'Até 10/06',
        'progress': 0.6,
      },
    ];

    return mockGoals.map((goal) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.blue200,
                  borderRadius: BorderRadius.circular(14.0)),
              padding: const EdgeInsets.all(5.0),
              child: Icon(goal['icon'], color: AppColors.blue700, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: AppFonts.poppinsSemiBold,
                      color: AppColors.blue900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal['date'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: AppFonts.poppinsRegular,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: goal['progress'],
                    backgroundColor: Colors.grey.shade300,
                    color: AppColors.blue500,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      );
    }).toList();
  }
}
