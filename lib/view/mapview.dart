import 'dart:async';

import 'package:PeachPedal/model/cycle_port_model.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as ml;

enum LocationSettingResult {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  enabled,
}

Future<LocationSettingResult> checkLocationSetting() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint('Location services are disabled.');
    return Future.value(LocationSettingResult.serviceDisabled);
  }
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('Location permissions are denied.');
      return Future.value(LocationSettingResult.permissionDenied);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    debugPrint('Location permissions are permanently denied.');
    return Future.value(LocationSettingResult.permissionDeniedForever);
  }
  return Future.value(LocationSettingResult.enabled);
}

Future<void> recoverLocationSettings(
    BuildContext context, LocationSettingResult locationResult) async {
  if (locationResult == LocationSettingResult.enabled) {
    return;
  }
  final result = await showOkCancelAlertDialog(
    context: context,
    okLabel: 'OK',
    cancelLabel: 'キャンセル',
    title: 'エラー',
    message: 'GPSの権限が有効ではありません。\nスマートフォンの設定アプリで設定を変更してください。',
  );
  if (result == OkCancelResult.cancel) {
    debugPrint('Cancel recover location settings.');
  } else {
    locationResult == LocationSettingResult.serviceDisabled
        ? await Geolocator.openLocationSettings()
        : await Geolocator.openAppSettings();
  }
}

class MapView extends StatefulWidget {
  final List<CyclePort> cyclePorts;

  const MapView({super.key, required this.cyclePorts});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  LatLng? _currentLocation;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(34.66813596243033, 133.9262377662192),
    zoom: 13.9,
  );
  int _selectedPortIndex = -1;

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _checkLocationSettings();
  }

  Future<void> _checkLocationSettings() async {
    final result = await checkLocationSetting();
    if (result != LocationSettingResult.enabled) {
      await recoverLocationSettings(context, result);
    }
  }

  Future<LatLng> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  String _formatLatLng(String lat, String lng) {
    final latDeg = double.parse(lat);
    final lngDeg = double.parse(lng);

    final latMin = (latDeg - latDeg.truncate()) * 60;
    final lngMin = (lngDeg - lngDeg.truncate()) * 60;

    final latSec = (latMin - latMin.truncate()) * 60;
    final lngSec = (lngMin - lngMin.truncate()) * 60;

    return "${latDeg.truncate()}°${latMin.truncate()}'${latSec.toStringAsFixed(1)}\"N ${lngDeg.truncate()}°${lngMin.truncate()}'${lngSec.toStringAsFixed(1)}\"E";
  }

  void _addMarkers() {
    setState(() {
      for (int i = 0; i < widget.cyclePorts.length; i++) {
        final port = widget.cyclePorts[i];
        final formattedPos = _formatLatLng(port.lat, port.lng);
        debugPrint(formattedPos);
        final lat = double.parse(port.lat);
        final lng = double.parse(port.lng);
        final latLng = LatLng(lat, lng);
        final rentCount = int.tryParse(port.rent) ?? 0;
        final pinColor = rentCount == 0
            ? BitmapDescriptor.hueRed
            : rentCount <= 3
                ? BitmapDescriptor.hueYellow
                : BitmapDescriptor.hueViolet;
        _markers.add(
          Marker(
            markerId: MarkerId(port.name),
            position: latLng,
            infoWindow: InfoWindow(
              title: port.name,
              snippet: '貸出可能: ${port.rent}, 返却可能: ${port.returnNumber}',
            ),
            onTap: () {
              setState(() {
                _selectedPortIndex = i;
              });
              _goToPort(port);
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(pinColor),
          ),
        );
      }
    });
  }

  Future<void> _goToPort(CyclePort port) async {
    final lat = double.tryParse(port.lat);
    final lng = double.tryParse(port.lng);
    if (lat != null && lng != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 17,
        ),
      ));
    }
  }

  Future<void> _goToCurrentLocation() async {
    final locationSettingResult = await checkLocationSetting();
    if (locationSettingResult != LocationSettingResult.enabled) {
      await recoverLocationSettings(context, locationSettingResult);
    }

    final currentLocation = await getCurrentLocation();
    _currentLocation = currentLocation;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentLocation,
        zoom: 17.0,
      ),
    ));
  }

  Future<void> _resetCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  Future<void> _launchNavigation(CyclePort port) async {
    final lat = double.parse(port.lat);
    final lng = double.parse(port.lng);
    final availableMaps = await ml.MapLauncher.installedMaps;
    if (availableMaps.isNotEmpty) {
      await availableMaps.first.showMarker(
        coords: ml.Coords(lat, lng),
        title: port.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポートマップ'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: widget.cyclePorts.length,
                controller: PageController(
                  viewportFraction: 0.8,
                  initialPage:
                      _selectedPortIndex != -1 ? _selectedPortIndex : 0,
                ),
                onPageChanged: (int index) {
                  setState(() {
                    _selectedPortIndex = index;
                  });
                  _goToPort(widget.cyclePorts[index]);
                },
                itemBuilder: (_, i) {
                  final port = widget.cyclePorts[i];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_selectedPortIndex == i) {
                            _launchNavigation(port);
                          } else {
                            setState(() {
                              _selectedPortIndex = i;
                            });
                            _goToPort(port);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                port.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.pedal_bike,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    '貸出可能: ${port.rent}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: int.parse(port.rent) == 0
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.bike_scooter_outlined,
                                      color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    '返却可能: ${port.returnNumber}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _goToCurrentLocation,
            tooltip: '現在地',
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _resetCameraPosition,
            tooltip: 'リセット',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: '戻る',
            child: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
