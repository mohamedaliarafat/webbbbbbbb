import 'package:customer/data/models/location_model.dart';
import 'package:customer/presentation/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final LocationModel? initialLocation;
  final bool isSelectionMode;

  const MapScreen({
    this.initialLocation,
    this.isSelectionMode = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = LatLng(
        widget.initialLocation!.lat,
        widget.initialLocation!.lng,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'اختر موقعاً' : 'الخريطة'),
        backgroundColor: Colors.orange,
        actions: widget.isSelectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.my_location),
                  onPressed: _goToCurrentLocation,
                  tooltip: 'الموقع الحالي',
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _selectedLocation != null ? _confirmSelection : null,
                  tooltip: 'تأكيد الاختيار',
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? _getDefaultLocation(),
              zoom: 14.0,
            ),
            markers: _buildMarkers(),
            onTap: widget.isSelectionMode ? _onMapTapped : null,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Current Location Button
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              child: Icon(Icons.my_location),
              mini: true,
            ),
          ),

          // Selection Instructions
          if (widget.isSelectionMode && _selectedLocation == null)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'انقر على الخريطة لاختيار الموقع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),

          // Selected Location Info
          if (widget.isSelectionMode && _selectedLocation != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الموقع المحدد:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'خط العرض: ${_selectedLocation!.latitude.toStringAsFixed(6)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'خط الطول: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmSelection,
                        child: Text('تأكيد الموقع'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _selectedMarker = Marker(
        markerId: MarkerId('selected_location'),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: 'الموقع المحدد'),
      );
    });
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (_selectedMarker != null) {
      markers.add(_selectedMarker!);
    }

    if (widget.initialLocation != null && _selectedLocation == null) {
      markers.add(
        Marker(
          markerId: MarkerId('initial_location'),
          position: LatLng(
            widget.initialLocation!.lat,
            widget.initialLocation!.lng,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'الموقع الحالي'),
        ),
      );
    }

    return markers;
  }

  void _goToCurrentLocation() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    
    if (locationProvider.currentLocation != null) {
      final currentLocation = locationProvider.currentLocation!;
      final latLng = LatLng(currentLocation.lat, currentLocation.lng);
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 16.0),
      );

      if (widget.isSelectionMode) {
        setState(() {
          _selectedLocation = latLng;
          _selectedMarker = Marker(
            markerId: MarkerId('selected_location'),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(title: 'الموقع الحالي'),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('جاري الحصول على الموقع الحالي...')),
      );
      await locationProvider.getCurrentLocation();
    }
  }

  void _confirmSelection() async {
    if (_selectedLocation != null) {
      try {
        // Get address from coordinates
        final locationProvider = Provider.of<LocationProvider>(context, listen: false);
        final locationModel = LocationModel(
          lat: _selectedLocation!.latitude,
          lng: _selectedLocation!.longitude,
          address: 'موقع محدد على الخريطة',
          lastUpdated: DateTime.now(),
        );

        // Return the selected location
        Navigator.pop(context, locationModel);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحديد الموقع: $e')),
        );
      }
    }
  }

  LatLng _getDefaultLocation() {
    // Default to Riyadh, Saudi Arabia
    return LatLng(24.7136, 46.6753);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}