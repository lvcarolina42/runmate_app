import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:runmate_app/presentation/post/controller/post_controller.dart';
import 'dart:convert';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_fonts.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late MapboxMap mapboxMap;
  final controller = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    // --- Cálculos das Estatísticas ---
    final double distanceInKm = controller.run!.distance / 1000;
    final bool hasDistance = distanceInKm > 0;
    final bool hasDuration = controller.run!.duration.inSeconds > 0;

    final String pace = hasDistance && hasDuration
        ? (controller.run!.duration.inMinutes / distanceInKm).toStringAsFixed(1)
        : '0.0';
    
    final String duration =
        '${controller.run!.duration.inMinutes.toString().padLeft(2, '0')}:${(controller.run!.duration.inSeconds % 60).toString().padLeft(2, '0')}';

    final String averageSpeed = hasDistance && hasDuration
        ? (distanceInKm / (controller.run!.duration.inSeconds / 3600)).toStringAsFixed(1)
        : '0.0';
    
    final stats = [
      {'icon': Icons.directions_run, 'label': 'Distância', 'value': '${distanceInKm.toStringAsFixed(2)} km', 'color': AppColors.orange400},
      {'icon': Icons.timer_outlined, 'label': 'Duração', 'value': duration, 'color': Colors.white},
      {'icon': Icons.speed, 'label': 'Ritmo Médio', 'value': '$pace min/km', 'color': AppColors.green200},
      {'icon': Icons.local_fire_department, 'label': 'Velocidade Média', 'value': '$averageSpeed km/h', 'color': AppColors.blue300},
    ];


    return Scaffold(
      extendBodyBehindAppBar: true, // Permite que o body fique atrás da AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: GetPlatform.isWeb ? 480 : 16.0),
        child: Stack(
          children: [
            // --- CAMADA 1: O MAPA ---
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GetPlatform.isWeb ? null : MapWidget(
                key: ValueKey("map_detail_${controller.run!.id}"),
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.DARK,
              ),
            ),
        
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.gray800.withOpacity(0.4),
                      AppColors.gray800,
                    ],
                    stops: const [0.0, 0.4, 0.6]
                  )
                ),
              ),
            ),
            
            // --- CAMADA 3: FOLHA DE CONTEÚDO DESLIZANTE ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Informações do Usuário e Título
                    _buildUserInfoAndTitle(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    
                    // Grid de Estatísticas
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.8, // Ajuste para o tamanho dos cards
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final stat = stats[index];
                        return _StatCard(
                          icon: stat['icon'] as IconData,
                          label: stat['label'] as String,
                          value: stat['value'] as String,
                          valueColor: stat['color'] as Color,
                        );
                      },
                    ),
                    const SizedBox(height: 80), // Espaço para o FAB não cobrir conteúdo
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/600?u=${controller.run!.userId}'),
              radius: 20.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              controller.run!.username,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.poppinsSemiBold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
             Text(
              DateFormat('dd/MM/yy', 'pt_BR').format(controller.run!.date),
              style: const TextStyle(
                color: AppColors.blue200,
                fontSize: 13.0,
                fontFamily: AppFonts.poppinsRegular,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          controller.run!.title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.poppinsBold,
            fontSize: 28,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // Funções do Mapa (sem alterações)
  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    if (controller.run!.checkPoints.isNotEmpty) {
      mapboxMap.setCamera(
        CameraOptions(
          center: Point(
            coordinates: Position(
              controller.run!.checkPoints.first.longitude,
              controller.run!.checkPoints.first.latitude,
            ),
          ),
          zoom: 12.0,
        ),
      );
    }
    if (controller.run!.checkPoints.length >= 2) {
      await _addRouteToMap();
    }
  }

  Future<void> _addRouteToMap() async {
    final coordinates = controller.run!.checkPoints
        .map((p) => [p.longitude, p.latitude])
        .toList();
    final geoJson = {
      "type": "Feature",
      "geometry": {"type": "LineString", "coordinates": coordinates},
    };
    final sourceId = "route_source_detail_${controller.run!.id}";
    final layerId = "route_layer_detail_${controller.run!.id}";
    final sourceExists = await mapboxMap.style.styleSourceExists(sourceId);
    if (!sourceExists) {
      await mapboxMap.style.addSource(GeoJsonSource(id: sourceId, data: jsonEncode(geoJson)));
    }
    final layerExists = await mapboxMap.style.styleLayerExists(layerId);
    if (!layerExists) {
      await mapboxMap.style.addLayer(
        LineLayer(
          id: layerId,
          sourceId: sourceId,
          lineColor: Colors.orange.value,
          lineWidth: 5.0,
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
        ),
      );
    }
    double minLat = controller.run!.checkPoints.first.latitude;
    double maxLat = controller.run!.checkPoints.first.latitude;
    double minLng = controller.run!.checkPoints.first.longitude;
    double maxLng = controller.run!.checkPoints.first.longitude;
    for (var coord in controller.run!.checkPoints) {
      minLat = coord.latitude < minLat ? coord.latitude : minLat;
      maxLat = coord.latitude > maxLat ? coord.latitude : maxLat;
      minLng = coord.longitude < minLng ? coord.longitude : minLng;
      maxLng = coord.longitude > maxLng ? coord.longitude : maxLng;
    }
    final bounds = CoordinateBounds(
      infiniteBounds: false,
      southwest: Point(coordinates: Position(minLng, minLat)),
      northeast: Point(coordinates: Position(maxLng, maxLat)),
    );
    final cameraOptions = await mapboxMap.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(top: 80.0, left: 40.0, bottom: (MediaQuery.of(context).size.height * 0.4), right: 40.0), // Padding ajustado
      null,
      null,
      null,
      null,
    );
    mapboxMap.setCamera(cameraOptions);
  }
}

// Novo widget para os cards de estatísticas
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.gray700,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.blue200, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 20.0,
              fontFamily: AppFonts.poppinsSemiBold,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.blue200,
              fontSize: 12.0,
              fontFamily: AppFonts.poppinsRegular,
            ),
          ),
        ],
      ),
    );
  }
}