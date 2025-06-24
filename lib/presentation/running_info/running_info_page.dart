import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:runmate_app/presentation/running_info/controller/running_info_controller.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_text_themes.dart';

class RunningInfoPage extends StatefulWidget {
  const RunningInfoPage({super.key});

  @override
  State<RunningInfoPage> createState() => _RunningInfoPageState();
}

class _RunningInfoPageState extends State<RunningInfoPage> {
  final RunningInfoController controller = Get.find<RunningInfoController>();
  late MapboxMap mapboxMap;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.blue950,
        appBar: AppBar(
          leading: const SizedBox(),
          title: Text("Resumo da Corrida", style: titleSmMedium.customColor(AppColors.whiteBrand)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Mapa
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: MapWidget(
                    key: const ValueKey("map_preview"),
                    onMapCreated: _onMapCreated,
                    styleUri: "mapbox://styles/lvcarolina42/cmbh4aepe003d01s63f2a8roe",
                    cameraOptions: CameraOptions(
                      center: controller.routeCoordinates.isNotEmpty
                          ? Point(
                              coordinates: Position(
                                controller.routeCoordinates.last.longitude,
                                controller.routeCoordinates.last.latitude,
                              ),
                            )
                          : null,
                      zoom: 15.0,
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        textcontroller: controller.titleController,
                        label: 'Título',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um título para a corrida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          _DataCard(
                            label: "Tempo",
                            value: controller.time,
                            icon: Icons.timer,
                          ),
                          const SizedBox(height: 12),
                          _DataCard(
                            label: "Distância",
                            value: controller.distance,
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
                            label: "Velocidade Média",
                            value: controller.averageSpeed,
                            icon: Icons.speed,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: controller.createRun,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange300,
                          foregroundColor: AppColors.blue950,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Salvar Corrida'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _onDiscardPressed,
                        child: const Text(
                          'Descartar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDiscardPressed() {
    Get.defaultDialog(
      title: 'Descartar Corrida?',
      middleText: 'Tem certeza que deseja descartar essa corrida?',
      backgroundColor: AppColors.blue900,
      titleStyle: titleSmRegular.customColor(AppColors.whiteBrand),
      middleTextStyle: bodyLgRegular.customColor(AppColors.whiteBrand),
      confirm: TextButton(
        onPressed: () {
          Get.back(); // Fecha o diálogo
          Get.back(); // Volta para a tela anterior
        },
        child: Text('Sim', style: bodyLgMedium.customColor(AppColors.orange300)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('Cancelar', style: bodyLgRegular.customColor(AppColors.blue100)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController textcontroller,
    required String label,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: textcontroller,
      obscureText: obscureText,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.formKey.currentState!.validate();
      },
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    if (controller.routeCoordinates.length < 2) return;

    final coordinates = controller.routeCoordinates
        .map((latLng) => [latLng.longitude, latLng.latitude])
        .toList();

    final geoJson = {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": coordinates,
      },
    };

    final geoJsonString = jsonEncode(geoJson);

    final style = mapboxMap.style;

    await style.addSource(
      GeoJsonSource(id: "route_source", data: geoJsonString),
    );

    await style.addLayer(
      LineLayer(
        id: "route_layer",
        sourceId: "route_source",
        lineColor: Colors.orange.value,
        lineWidth: 3.0,
      ),
    );

    // Ajuste de câmera para mostrar toda a rota
    double minLat = controller.routeCoordinates.first.latitude;
    double maxLat = controller.routeCoordinates.first.latitude;
    double minLng = controller.routeCoordinates.first.longitude;
    double maxLng = controller.routeCoordinates.first.longitude;

    for (var coord in controller.routeCoordinates) {
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
      MbxEdgeInsets(
        top: 100,
        bottom: 100,
        left: 100,
        right: 100,
      ),
      null,
      null,
      null,
      null,
    );

    mapboxMap.setCamera(cameraOptions);
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
        color: AppColors.blue900,
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
