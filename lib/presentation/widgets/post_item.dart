import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:runmate_app/domain/run/model/run.dart'; // Certifique-se que este import está correto para o seu projeto
import 'package:runmate_app/shared/themes/app_colors.dart'; // Certifique-se que este import está correto para o seu projeto
import 'package:runmate_app/shared/themes/app_fonts.dart'; // Certifique-se que este import está correto para o seu projeto

class PostItem extends StatefulWidget {
  final Run run;
  const PostItem({super.key, required this.run});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // A instância do MapboxMap é declarada aqui, mas será inicializada no _onMapCreated.
  late MapboxMap mapboxMap;

  @override
  Widget build(BuildContext context) {
    // Lógica para cálculo de pace e duração movida para o build.
    final bool hasDistance = widget.run.distance > 0;
    final String pace = hasDistance
        ? (widget.run.duration.inMinutes / (widget.run.distance / 1000))
            .toStringAsFixed(1)
        : '0.0';

    final String duration =
        '${widget.run.duration.inMinutes.toString().padLeft(2, '0')}:${(widget.run.duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Adicionado um espaçamento vertical
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com informações do usuário
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/600?u=${widget.run.userId}',
                ),
                radius: 20.0,
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.run.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.poppinsSemiBold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    // Formatando a data para um formato mais legível
                    DateFormat('dd MMMM yyyy, HH:mm', 'pt_BR')
                        .format(widget.run.date),
                    style: const TextStyle(
                      color: AppColors.blue300,
                      fontSize: 12.0,
                      fontFamily: AppFonts.poppinsRegular,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          // Widget do Mapa
          SizedBox(
            height: 170,
            width: double.infinity, // Garante que o mapa ocupe toda a largura
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: MapWidget(
                key: ValueKey("map_preview_${widget.run.id}"),
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.DARK,
                cameraOptions: CameraOptions(
                  // Centraliza o mapa no ponto inicial da corrida ou em (0,0) se não houver pontos.
                  center: widget.run.checkPoints.isNotEmpty
                      ? Point(
                          coordinates: Position(
                            widget.run.checkPoints.first.longitude,
                            widget.run.checkPoints.first.latitude,
                          ),
                        )
                      : Point(coordinates: Position(0, 0)),
                  zoom: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          // Título da corrida
          Text(
            widget.run.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: AppFonts.poppinsMedium,
            ),
          ),
          const SizedBox(height: 12.0),
          // Estatísticas da corrida
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'Distância',
                value: '${(widget.run.distance / 1000).toStringAsFixed(2)} km',
                valueColor: AppColors.orange400,
              ),
              _StatItem(
                label: 'Duração',
                value: duration,
                valueColor: Colors.white,
              ),
              _StatItem(
                label: 'Ritmo',
                value: '$pace min/km',
                valueColor: AppColors.green200,
              ),
            ],
          )
        ],
      ),
    );
  }

  /// **CORREÇÃO PRINCIPAL**
  /// Este método é chamado quando o widget do mapa é inicializado.
  /// A lógica de adicionar a rota foi movida para o listener `onStyleLoaded`.
  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Adiciona um listener que será disparado QUANDO o estilo do mapa (MapboxStyles.DARK)
    // for completamente carregado e estiver pronto para receber modificações.
      // Só tenta adicionar a rota se houver pontos suficientes para formar uma linha.
    if (widget.run.checkPoints.length >= 2) {
      _addRouteToMap();
    }
  }

  /// **CÓDIGO CORRIGIDO E MELHORADO**
  /// Adiciona a rota (fonte e camada) ao mapa e ajusta a câmera.
  Future<void> _addRouteToMap() async {
    // Define IDs únicos para a fonte e a camada usando o ID da corrida.
    final sourceId = "route_source_${widget.run.id}";
    final layerId = "route_layer_${widget.run.id}";

    // BOA PRÁTICA: Verifica se a fonte já existe no estilo do mapa.
    // Isso previne erros caso o widget seja reconstruído (rebuild).
    final sourceExists = await mapboxMap.style.styleSourceExists(sourceId);
    if (sourceExists) {
      // Se a fonte já existe, não faz nada para evitar o erro "source already exists".
      return; 
    }

    // Converte a lista de checkpoints para o formato que o GeoJSON espera.
    final coordinates = widget.run.checkPoints
        .map((p) => [p.longitude, p.latitude])
        .toList();

    // Cria o objeto GeoJSON para uma "LineString" (linha).
    final geoJson = {
      "type": "Feature",
      "properties": {},
      "geometry": {"type": "LineString", "coordinates": coordinates},
    };

    // 1. Adiciona a fonte de dados (Source) ao mapa.
    await mapboxMap.style.addSource(
      GeoJsonSource(id: sourceId, data: jsonEncode(geoJson)),
    );
        
    // 2. Adiciona a camada de visualização (Layer) que desenhará a linha.
    // Isso agora é seguro porque estamos dentro do callback onStyleLoaded.
    await mapboxMap.style.addLayer(
      LineLayer(
        id: layerId,
        sourceId: sourceId, // Aponta para a fonte criada acima.
        lineColor: Colors.orange.value,
        lineWidth: 4.0,
        lineCap: LineCap.ROUND, // Melhora a aparência das pontas da linha.
        lineJoin: LineJoin.ROUND, // Melhora a aparência das curvas.
      ),
    );

    // 3. Calcula os limites (bounds) da rota para ajustar a câmera.
    double minLat = widget.run.checkPoints.first.latitude;
    double maxLat = widget.run.checkPoints.first.latitude;
    double minLng = widget.run.checkPoints.first.longitude;
    double maxLng = widget.run.checkPoints.first.longitude;

    for (var coord in widget.run.checkPoints) {
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

    // 4. Pede ao Mapbox para calcular a melhor CameraOptions para enquadrar a rota.
    final cameraOptions = await mapboxMap.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(top: 40, bottom: 40, left: 40, right: 40),
      null,
      null,
      null,
      null,
    );

    // 5. Anima a câmera para a nova posição.
    mapboxMap.setCamera(cameraOptions);
  }
}

/// Widget auxiliar para exibir cada estatística (Distância, Duração, Ritmo).
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.blue200,
            fontSize: 11.0,
            fontFamily: AppFonts.poppinsRegular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14.0,
            fontFamily: AppFonts.poppinsMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}