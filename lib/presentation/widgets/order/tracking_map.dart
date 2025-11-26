
import 'dart:math';

import 'package:customer/data/models/location_model.dart';
import 'package:customer/presentation/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class TrackingMap extends StatefulWidget {
  final LocationModel? pickupLocation;
  final LocationModel? deliveryLocation;
  final LocationModel? currentLocation;
  final List<LocationModel>? routePoints;
  final bool showUserLocation;
  final bool showRoute;
  final Function(LocationModel)? onLocationSelected;

  const TrackingMap({
    Key? key,
    this.pickupLocation,
    this.deliveryLocation,
    this.currentLocation,
    this.routePoints,
    this.showUserLocation = true,
    this.showRoute = true,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  _TrackingMapState createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLngBounds? _bounds;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMap();
    });
  }

  @override
  void didUpdateWidget(TrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMap();
  }

  void _updateMap() {
    _updateMarkers();
    _updatePolylines();
    _fitToBounds();
  }

  void _updateMarkers() {
    _markers.clear();

    // نقطة الالتقاط
    if (widget.pickupLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: LatLng(
            widget.pickupLocation!.lat,
            widget.pickupLocation!.lng,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: 'نقطة الالتقاط',
            snippet: widget.pickupLocation!.address,
          ),
        ),
      );
    }

    // نقطة التسليم
    if (widget.deliveryLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('delivery'),
          position: LatLng(
            widget.deliveryLocation!.lat,
            widget.deliveryLocation!.lng,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'نقطة التسليم',
            snippet: widget.deliveryLocation!.address,
          ),
        ),
      );
    }

    // الموقع الحالي للسائق
    if (widget.currentLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('driver'),
          position: LatLng(
            widget.currentLocation!.lat,
            widget.currentLocation!.lng,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'موقع السائق',
            snippet: 'يتم التوصيل الآن',
          ),
          rotation: 45.0, // اتجاه السائق
        ),
      );
    }

    // موقع المستخدم الحالي
    if (widget.showUserLocation) {
      final locationProvider = context.read<LocationProvider>();
      if (locationProvider.currentLocation != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('user'),
            position: LatLng(
              locationProvider.currentLocation!.lat,
              locationProvider.currentLocation!.lng,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(title: 'موقعك الحالي'),
          ),
        );
      }
    }

    setState(() {});
  }

  void _updatePolylines() {
    _polylines.clear();

    if (widget.showRoute && widget.routePoints != null && widget.routePoints!.length > 1) {
      final List<LatLng> points = widget.routePoints!
          .map((location) => LatLng(location.lat, location.lng))
          .toList();

      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    // رسم خط من السائق لنقطة التسليم
    if (widget.currentLocation != null && widget.deliveryLocation != null) {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('driver_to_delivery'),
          points: [
            LatLng(widget.currentLocation!.lat, widget.currentLocation!.lng),
            LatLng(widget.deliveryLocation!.lat, widget.deliveryLocation!.lng),
          ],
          color: Colors.green,
          width: 3,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)],
        ),
      );
    }

    setState(() {});
  }

  void _fitToBounds() {
    if (_markers.isEmpty) return;

    final List<LatLng> points = _markers.map((marker) => marker.position).toList();

    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    _bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(_bounds!, 50.0),
    );
  }

  LatLng _getInitialCameraPosition() {
    if (widget.pickupLocation != null) {
      return LatLng(widget.pickupLocation!.lat, widget.pickupLocation!.lng);
    } else if (widget.deliveryLocation != null) {
      return LatLng(widget.deliveryLocation!.lat, widget.deliveryLocation!.lng);
    } else {
      // موقع افتراضي (الرياض)
      return LatLng(24.7136, 46.6753);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            _updateMap();
          },
          initialCameraPosition: CameraPosition(
            target: _getInitialCameraPosition(),
            zoom: 14.0,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: widget.showUserLocation,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onTap: (latLng) {
            if (widget.onLocationSelected != null) {
              widget.onLocationSelected!(
                LocationModel(
                  lat: latLng.latitude,
                  lng: latLng.longitude,
                  address: 'موقع مختار',
                  lastUpdated: DateTime.now(),
                ),
              );
            }
          },
        ),

        // زر تحديد الموقع الحالي
        if (widget.showUserLocation)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _goToUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),

        // معلومات التتبع
        if (widget.currentLocation != null && widget.deliveryLocation != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _TrackingInfoCard(
              currentLocation: widget.currentLocation!,
              deliveryLocation: widget.deliveryLocation!,
            ),
          ),

        // وسيلة إيضاح الخريطة
        Positioned(
          bottom: 80,
          left: 16,
          child: _MapLegend(),
        ),
      ],
    );
  }

  void _goToUserLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.getCurrentLocation();

    if (locationProvider.currentLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            locationProvider.currentLocation!.lat,
            locationProvider.currentLocation!.lng,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _TrackingInfoCard extends StatelessWidget {
  final LocationModel currentLocation;
  final LocationModel deliveryLocation;

  const _TrackingInfoCard({
    required this.currentLocation,
    required this.deliveryLocation,
  });

  double _calculateDistance() {
    // حساب المسافة التقريبية (Haversine formula مبسطة)
    final double lat1 = currentLocation.lat * (3.141592653589793 / 180.0);
    final double lon1 = currentLocation.lng * (3.141592653589793 / 180.0);
    final double lat2 = deliveryLocation.lat * (3.141592653589793 / 180.0);
    final double lon2 = deliveryLocation.lng * (3.141592653589793 / 180.0);

    final double dlat = lat2 - lat1;
    final double dlon = lon2 - lon1;

    final double a = 
        Math.sin(dlat / 2) * Math.sin(dlat / 2) +
        Math.cos(lat1) * Math.cos(lat2) * 
        Math.sin(dlon / 2) * Math.sin(dlon / 2);
    
    final double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    final double distance = 6371 * c; // نصف قطر الأرض بالكيلومتر

    return distance;
  }

  String _formatDistance(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).toStringAsFixed(0)} متر';
    } else {
      return '${distance.toStringAsFixed(1)} كم';
    }
  }

  String _estimateTime(double distance) {
    // تقدير الوقت بناء على سرعة متوسطة 30 كم/ساعة
    final double timeInHours = distance / 30.0;
    if (timeInHours < 1) {
      return '${(timeInHours * 60).toStringAsFixed(0)} دقيقة';
    } else {
      return '${timeInHours.toStringAsFixed(1)} ساعة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = _calculateDistance();
    final estimatedTime = _estimateTime(distance);

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'موقع السائق الحالي',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              currentLocation.address,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _InfoItem(
                  icon: Icons.space_dashboard,
                  value: _formatDistance(distance),
                  label: 'المسافة المتبقية',
                ),
                SizedBox(width: 16),
                _InfoItem(
                  icon: Icons.access_time,
                  value: estimatedTime,
                  label: 'الوقت المتوقع',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.green),
            SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(
              color: Colors.green,
              text: 'نقطة الالتقاط',
            ),
            SizedBox(height: 4),
            _LegendItem(
              color: Colors.red,
              text: 'نقطة التسليم',
            ),
            SizedBox(height: 4),
            _LegendItem(
              color: Colors.blue,
              text: 'موقع السائق',
            ),
            SizedBox(height: 4),
            _LegendItem(
              color: Colors.orange,
              text: 'موقعك',
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

// دالة مساعدة للحسابات الرياضية

class Math {
  static double sin(double x) => sin(x % (2 * pi));
  static double cos(double x) => cos(x % (2 * pi));
  static double atan2(double y, double x) => atan2(y, x);
  static double sqrt(double x) => sqrt(x);
}