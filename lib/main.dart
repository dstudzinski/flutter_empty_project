import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _lat = 0;
  double _lon = 0;
  Key _panoramaKey = Key('key');
  bool _generateNewKey = false;
  bool _useSmallImage = false;
  bool _useBlankScreenWorkaround = false;
  bool _showDummy = false;

  void _handleOnTap(double latitude, double longitude) {
    setState(() {
      _lat = latitude;
      _lon = longitude;

      if (_generateNewKey) {
        _panoramaKey = Key('$latitude $longitude');
      }

      if (_useBlankScreenWorkaround) {
        _showDummy = true;
      }
    });
  }

  void _showProperImage() {
    setState(() {
      _showDummy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Image image = _useBlankScreenWorkaround && _showDummy
        ? Image.asset('assets/dummy.jpg')
        : _useSmallImage
            ? Image.asset('assets/panorama_small.jpg')
            : Image.asset('assets/panorama_big.jpg');

    return Scaffold(
        body: Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
          width: MediaQuery.of(context).size.width - 300,
          height: MediaQuery.of(context).size.height,
          child: Panorama(
            key: _panoramaKey,
            latitude: _lat,
            longitude: _lon,
            child: image,
            onTap: (double longitude, double latitude, double tilt) {
              _handleOnTap(latitude, longitude);
            },
            onViewChanged: (double longitude, double latitude, double tilt) {
              _showProperImage();
            },
          ),
        ),
        Container(
          width: 300,
          child: Column(
            children: [
              SelectableText('lat: $_lat\nlon: $_lon'),
              CheckboxListTile(
                title: const Text('Generate new key for panorama widget?'),
                value: _generateNewKey,
                onChanged: (bool? value) {
                  setState(() {
                    _generateNewKey = !_generateNewKey;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Use small image?'),
                value: _useSmallImage,
                onChanged: (bool? value) {
                  setState(() {
                    _useSmallImage = !_useSmallImage;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Use blank screen workaround?'),
                value: _useBlankScreenWorkaround,
                onChanged: (bool? value) {
                  setState(() {
                    _useBlankScreenWorkaround = !_useBlankScreenWorkaround;
                  });
                },
              )
            ],
          ),
        )
      ],
    ));
  }
}
