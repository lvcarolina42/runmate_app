import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  final CameraOptions cameraOptions;
  final void Function(MapboxMap mapboxMap)? onMapCreatedCallback;

  const MapsWidget({
    super.key,
    this.onMapCreatedCallback,
    required this.cameraOptions,
  });

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  MapboxMap? mapboxMap;
  CircleAnnotationManager? pointAnnotationManager;

  late CircleAnnotationManager _circleAnnotationManager;

  onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;

    _circleAnnotationManager = await mapboxMap.annotations.createCircleAnnotationManager();

    _addUserLocationCircle();
    
    pointAnnotationManager =
        await mapboxMap.annotations.createCircleAnnotationManager();

    CircleAnnotationOptions pointAnnotationOptions = CircleAnnotationOptions(
      geometry: Point(coordinates: Position(-43.9935084, -19.9238965)),
    );

    pointAnnotationManager?.create(pointAnnotationOptions);
    
    /// When a POI feature in the Standard POI featureset is tapped hide the POI
    var tapInteractionPOI = TapInteraction(StandardPOIs(), (feature, _) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
          feature, StandardPOIsState(hide: true));

      /// Not stopping propagation means that the tap event will be propagated to other interactions.
    }, radius: 10, stopPropagation: false);
    mapboxMap.addInteraction(tapInteractionPOI,
        interactionID: "tap_interaction_poi");

    /// When a building in the Standard Buildings featureset is tapped, set that building as highlighted to color it.
    var tapInteractionBuildings =
        TapInteraction(StandardBuildings(), (feature, _) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
          feature, StandardBuildingsState(highlight: true));
    });
    mapboxMap.addInteraction(tapInteractionBuildings);

    /// When a place label in the Standard Place Labels featureset is tapped, set that place label as selected.
    var tapInteractionPlaceLabel =
        TapInteraction(StandardPlaceLabels(), (feature, _) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
          feature, StandardPlaceLabelsState(select: true));
    });
    mapboxMap.addInteraction(tapInteractionPlaceLabel);

    // When the map is long-tapped print the screen coordinates of the tap
    // and reset the state of all features in the Standard POIs, Buildings, and Place Labels featuresets.
    var longTapInteraction = LongTapInteraction.onMap((context) {
      mapboxMap.resetFeatureStatesForFeatureset(StandardPOIs());
      mapboxMap.resetFeatureStatesForFeatureset(StandardBuildings());
      mapboxMap.resetFeatureStatesForFeatureset(StandardPlaceLabels());
    });
    mapboxMap.addInteraction(longTapInteraction);

    widget.onMapCreatedCallback?.call(mapboxMap);
  }

  void _addUserLocationCircle() {
  final userPosition = Point(
    coordinates: Position(
      widget.cameraOptions.center?.coordinates.lng ?? 0,
      widget.cameraOptions.center?.coordinates.lat ?? 0,
    ),
  );

  _circleAnnotationManager.create(CircleAnnotationOptions(
    geometry: userPosition,
    circleRadius: 10.0,
    circleOpacity: 0.6,
    circleStrokeWidth: 20.0,
  ));
}

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey("mapWidget"),
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(widget.cameraOptions.center?.coordinates.lng ?? 0, widget.cameraOptions.center?.coordinates.lat ?? 0)),
          bearing: 49.92,
          zoom: 16.35,
          pitch: 40),
      styleUri: "mapbox://styles/lvcarolina42/cmbh4aepe003d01s63f2a8roe",
      textureView: false,
      onMapCreated: onMapCreated,
      mapOptions: MapOptions(
        pixelRatio: 1.0,
      )
    );
  }
}