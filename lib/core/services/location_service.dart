import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final Logger _logger = Logger();
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      _logger.i('📍 Location service enabled: $serviceEnabled');
      return serviceEnabled;
    } catch (e) {
      _logger.e('❌ Error checking location service: $e');
      return false;
    }
  }

  // Check location permissions
  Future<LocationPermission> checkPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      _logger.i('🔐 Location permission: $permission');
      return permission;
    } catch (e) {
      _logger.e('❌ Error checking location permission: $e');
      return LocationPermission.denied;
    }
  }

  // Request location permissions
  Future<LocationPermission> requestPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      _logger.i('🔐 Requested location permission: $permission');
      return permission;
    } catch (e) {
      _logger.e('❌ Error requesting location permission: $e');
      return LocationPermission.denied;
    }
  }

  // Get current position
  Future<Position?> getCurrentPosition({
    bool forceRefresh = false,
  }) async {
    try {
      // Check if we already have a recent position
      if (!forceRefresh && 
          _currentPosition != null && 
          _isPositionRecent(_currentPosition!)) {
        _logger.i('📍 Using cached recent position');
        return _currentPosition;
      }

      // Check location service
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'خدمة الموقع غير مفعلة. يرجى تفعيل خدمة الموقع';
      }

      // Check permissions
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw 'تم رفض إذن الموقع. يرجى منح إذن الموقع من إعدادات التطبيق';
      }

      // Get current position - ✅ التحديث للإصدار 14
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );

      _currentPosition = position;
      _logger.i('📍 Current position: ${position.latitude}, ${position.longitude}');

      return position;
    } on TimeoutException {
      _logger.e('❌ Timeout getting current position');
      throw 'انتهت مهلة الحصول على الموقع. يرجى المحاولة مرة أخرى';
    } catch (e) {
      _logger.e('❌ Error getting current position: $e');
      rethrow;
    }
  }

  // Check if position is recent (less than 5 minutes old)
  bool _isPositionRecent(Position position) {
    if (position.timestamp == null) return false; // ✅ إصلاح مشكلة null
    final age = DateTime.now().difference(position.timestamp!);
    return age.inMinutes < 5;
  }

  // Get address from coordinates
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        
        // Build address string
        String address = _buildAddressString(placemark);
        _logger.i('🏠 Address from coordinates: $address');
        
        return address;
      }
      
      return 'عنوان غير معروف';
    } catch (e) {
      _logger.e('❌ Error getting address from coordinates: $e');
      return 'تعذر الحصول على العنوان';
    }
  }

  // Get coordinates from address
  Future<Location?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        Location location = locations.first;
        _logger.i('📍 Coordinates from address: ${location.latitude}, ${location.longitude}');
        return location;
      }
      
      return null;
    } catch (e) {
      _logger.e('❌ Error getting coordinates from address: $e');
      return null;
    }
  }

  // Build address string from placemark
  String _buildAddressString(Placemark placemark) {
    List<String> addressParts = [];
    
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      addressParts.add(placemark.subLocality!);
    }
    
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }
    
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      addressParts.add(placemark.country!);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'عنوان غير معروف';
  }

  // Calculate distance between two points in meters
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    try {
      double distance = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      _logger.i('📏 Distance calculated: ${distance.toStringAsFixed(2)} meters');
      return distance;
    } catch (e) {
      _logger.e('❌ Error calculating distance: $e');
      return 0.0;
    }
  }

  // Calculate distance in kilometers
  double calculateDistanceInKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    double distanceInMeters = calculateDistance(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );

    return distanceInMeters / 1000;
  }

  // Get last known position
  Future<Position?> getLastKnownPosition() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _logger.i('📍 Last known position: ${position.latitude}, ${position.longitude}');
        _currentPosition = position;
      }
      return position;
    } catch (e) {
      _logger.e('❌ Error getting last known position: $e');
      return null;
    }
  }

  // Watch position changes - ✅ التحديث للإصدار 14
 // Watch position changes - ✅ التحديث للإصدار 14
Stream<Position> watchPosition({
  LocationAccuracy accuracy = LocationAccuracy.best,
  int distanceFilter = 10, // ✅ تغيير من double إلى int
}) {
  try {
    _logger.i('👀 Starting position watch');
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter, // ✅ الآن صحيح
      ),
    ).handleError((error) {
      _logger.e('❌ Error in position stream: $error');
      throw error;
    });
  } catch (e) {
    _logger.e('❌ Error watching position: $e');
    return Stream.error(e);
  }
}

  // Stop watching position
  void stopWatching() {
    // Note: The stream from getPositionStream automatically closes
    // when the listener is cancelled
    _logger.i('🛑 Stopped position watch');
  }

  // Check if location is within radius
  bool isWithinRadius({
    required double centerLatitude,
    required double centerLongitude,
    required double radiusInMeters,
    required double targetLatitude,
    required double targetLongitude,
  }) {
    double distance = calculateDistance(
      startLatitude: centerLatitude,
      startLongitude: centerLongitude,
      endLatitude: targetLatitude,
      endLongitude: targetLongitude,
    );

    return distance <= radiusInMeters;
  }

  // Get formatted distance string
  String getFormattedDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} م';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} كم';
    }
  }

  // Get bearing between two points
  double getBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    try {
      double bearing = Geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      _logger.i('🧭 Bearing calculated: ${bearing.toStringAsFixed(2)}°');
      return bearing;
    } catch (e) {
      _logger.e('❌ Error calculating bearing: $e');
      return 0.0;
    }
  }

  // Validate coordinates
  bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 && 
           latitude <= 90 && 
           longitude >= -180 && 
           longitude <= 180;
  }

  // Get approximate area name
  Future<String?> getAreaName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return placemark.locality ?? placemark.administrativeArea ?? placemark.subLocality;
      }
      
      return null;
    } catch (e) {
      _logger.e('❌ Error getting area name: $e');
      return null;
    }
  }

  // Clear cached position
  void clearCachedPosition() {
    _currentPosition = null;
    _logger.i('🗑️ Cleared cached position');
  }

  // ✅ دالة جديدة: فتح إعدادات الموقع
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
      _logger.i('⚙️ Opened location settings');
    } catch (e) {
      _logger.e('❌ Error opening location settings: $e');
      rethrow;
    }
  }

  // ✅ دالة جديدة: فتح إعدادات التطبيق
  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
      _logger.i('⚙️ Opened app settings');
    } catch (e) {
      _logger.e('❌ Error opening app settings: $e');
      rethrow;
    }
  }

  // ✅ دالة جديدة: الحصول على الموقع والعنوان معاً
  Future<Map<String, dynamic>?> getCurrentLocationWithAddress() async {
    try {
      final position = await getCurrentPosition();
      if (position != null) {
        final address = await getAddressFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        
        return {
          'position': position,
          'address': address,
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
      }
      return null;
    } catch (e) {
      _logger.e('❌ Error getting location with address: $e');
      return null;
    }
  }

  // ✅ دالة جديدة: التحقق من كل الصلاحيات والخدمات
  Future<bool> checkLocationAvailability() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      final permission = await checkPermission();
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      _logger.e('❌ Error checking location availability: $e');
      return false;
    }
  }
}