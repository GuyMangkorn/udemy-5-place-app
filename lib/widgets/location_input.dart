import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screens/map_screen.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput({required this.onSelectPlace});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previceImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMap = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previceImageUrl = staticMap;
    });
    widget.onSelectPlace(lat, lat);
  }

  Future<void> _getCurrentLocation() async {
    // NOTE เก็ท lat lon ที่อยู่ปัจจุบัน
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude!, locData.longitude!);
    } catch (err) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    //** NOTE เพื่อรับค่าที่จะคืนกลับมาจากการ poped สกรีน */
    // final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
    // NOTE alternative way
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    // widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previceImageUrl == null
              ? const Text(
                  'No location Chosse',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previceImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Slelect on Map'),
            ),
          ],
        )
      ],
    );
  }
}
