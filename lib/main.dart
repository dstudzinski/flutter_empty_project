import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_mbtiles/vector_mbtiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    as vector_tile_renderer;

import 'osm_bright_ja_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VectorMBTiles example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VectorMBTiles example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(35.68132332775388, 139.76712479771956),
                zoom: 11,
                maxZoom: 18,
              ),
              children: [
                VectorTileLayer(
                  key: const Key('VectorTileLayerWidget'),
                  theme: _mapTheme(context),
                  tileProviders: TileProviders(
                      {'openmaptiles': _cachingTileProvider(_basemapPath())}),
                ),
              ]),
        ));
  }
}

VectorTileProvider _cachingTileProvider(String mbtilesPath) {
  return MemoryCacheVectorTileProvider(
      delegate: VectorMBTilesProvider(
          mbtilesPath: mbtilesPath,
          // this is the maximum zoom of the provider, not the
          // maximum of the map. vector tiles are rendered
          // to larger sizes to support higher zoom levels
          maximumZoom: 14),
      maxSizeBytes: 1024 * 1024 * 2);
}

_mapTheme(BuildContext context) {
  // maps are rendered using themes
  // to provide a dark theme do something like this:
  // if (MediaQuery.of(context).platformBrightness == Brightness.dark) return myDarkTheme();
  return OSMBrightTheme.osmBrightJaTheme();
}

extension OSMBrightTheme on ProvidedThemes {
  static vector_tile_renderer.Theme osmBrightJaTheme({Logger? logger}) =>
      ThemeReader(logger: logger).read(osmBrightJaStyle());
}

String _basemapPath() {
  // return 'assets/maps/countries.mbtiles';
  return 'assets/maps/example.mbtiles';
}
