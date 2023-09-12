import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Map Tile Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapTileCalculator(),
    );
  }
}

class MapTileCalculator extends StatefulWidget {
  @override
  _MapTileCalculatorState createState() => _MapTileCalculatorState();
}

class _MapTileCalculatorState extends State<MapTileCalculator> {
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  TextEditingController zoomController = TextEditingController();
  String tileUrl = '';
  String xCoord = '';
  String yCoord = '';

  @override
  void dispose() {
    latController.dispose();
    lngController.dispose();
    zoomController.dispose();
    super.dispose();
  }

  void calculateTile() {
    double latitude = double.tryParse(latController.text) ?? 0.0;
    double longitude = double.tryParse(lngController.text) ?? 0.0;
    int zoom = int.tryParse(zoomController.text) ?? 0;

    if (latitude != 0.0 && longitude != 0.0 && zoom > 0) {
      int x = ((longitude + 180) / 360 * (1 << zoom)).floor();
      int y = ((1 -
                  log(tan(latitude * pi / 180) + 1 / cos(latitude * pi / 180)) /
                      pi) /
              2 *
              (1 << zoom))
          .floor();

      // Yandex Map Tile URL
      String calculatedTileUrl =
          'https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?'
          'l=carparks&x=$x&y=$y&z=$zoom&scale=1&lang=ru_RU';

      setState(() {
        tileUrl = calculatedTileUrl;
        xCoord = x.toString();
        yCoord = y.toString();
      });
    } else {
      // Handle the case where the input data is invalid.
      print('Error: Invalid input data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yandex Map Tile Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: latController,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            TextFormField(
              controller: lngController,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            TextFormField(
              controller: zoomController,
              decoration: const InputDecoration(labelText: 'Zoom Level'),
            ),
            ElevatedButton(
              onPressed: calculateTile,
              child: const Text('Calculate'),
            ),
            // Image Widget wrapped in a conditional to handle image loading errors
            tileUrl.isNotEmpty
                ? Image.network(tileUrl) // Display the map tile
                : const Text('Map tile will appear here'),
            Text('X Coordinate: $xCoord'),
            Text('Y Coordinate: $yCoord'),
          ],
        ),
      ),
    );
  }
}
