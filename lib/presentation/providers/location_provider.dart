// ignore_for_file: unused_element

import 'dart:async';


import 'package:customer/data/models/location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  LocationModel? _currentLocation;
  List<LocationModel> _recentLocations = [];
  bool _isLoading = false;
  String _error = '';
  bool _locationServiceEnabled = false;
  LocationPermission _locationPermission = LocationPermission.denied;

  LocationModel? get currentLocation => _currentLocation;
  List<LocationModel> get recentLocations => List.unmodifiable(_recentLocations);
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get locationServiceEnabled => _locationServiceEnabled;
  LocationPermission get locationPermission => _locationPermission;

  // دالة notify آمنة
  void _safeNotifyListeners() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> initializeLocation() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      // الخطوة 1: التحقق من خدمة الموقع
      _locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_locationServiceEnabled) {
        _isLoading = false;
        _error = 'خدمة الموقع غير مفعلة. يرجى تفعيلها.';
        _safeNotifyListeners();
        return;
      }

      // الخطوة 2: التحقق من الصلاحيات وطلبها إذا لزم الأمر
      await _checkAndRequestPermission();

      // الخطوة 3: إذا الصلاحيات ممنوحة، احصل على الموقع
      if (_locationPermission == LocationPermission.whileInUse || 
          _locationPermission == LocationPermission.always) {
        await getCurrentLocation();
      } else {
        _isLoading = false;
        _error = 'صلاحيات الموقع مطلوبة لتحديد موقعك.';
        _safeNotifyListeners();
      }
      
    } catch (e) {
      _isLoading = false;
      _error = 'خطأ في الحصول على الموقع: $e';
      _safeNotifyListeners();
    }
  }

  Future<void> _checkAndRequestPermission() async {
    // التحقق من الصلاحيات الحالية
    _locationPermission = await Geolocator.checkPermission();
    
    if (_locationPermission == LocationPermission.denied) {
      // طلب الصلاحيات للمرة الأولى
      _locationPermission = await Geolocator.requestPermission();
      _safeNotifyListeners();
    }
    
    if (_locationPermission == LocationPermission.deniedForever) {
      _error = 'تم رفض صلاحيات الموقع بشكل دائم. يرجى تفعيلها من إعدادات الجهاز.';
      _safeNotifyListeners();
      return;
    }
    
    if (_locationPermission == LocationPermission.whileInUse || 
        _locationPermission == LocationPermission.always) {
      _error = ''; // مسح أي أخطاء سابقة إذا منحت الصلاحيات
    }
  }

  Future<void> getCurrentLocation() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      // ✅ التحديث للإصدار 14.0.2 - استخدام LocationSettings
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );

      // ✅ التحقق من أن الموقع في السعودية
      if (!_isLocationInSaudiArabia(position.latitude, position.longitude)) {
        throw 'الموقع المحدد خارج المملكة العربية السعودية. يرجى التأكد من إعدادات الموقع';
      }

      // الحصول على العنوان من الإحداثيات
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('لم يتم العثور على عنوان للإحداثيات');
      }

      final Placemark placemark = placemarks.first;
      final String address = _buildAddress(placemark);

      final newLocation = LocationModel(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
        lastUpdated: DateTime.now(),
      );

      _currentLocation = newLocation;
      _addToRecentLocations(newLocation);
      
      _isLoading = false;
      _safeNotifyListeners();
      
    } on TimeoutException {
      _isLoading = false;
      _error = 'انتهت مهلة الحصول على الموقع. يرجى المحاولة مرة أخرى.';
      _safeNotifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  // ✅ دالة محسنة مع إعادة المحاولة
  Future<void> getCurrentLocationWithRetry({int maxRetries = 2}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await getCurrentLocation();
        
        // إذا نجح وكان الموقع في السعودية، توقف
        if (_currentLocation != null && _isLocationInSaudiArabia(_currentLocation!.lat, _currentLocation!.lng)) {
          return;
        }
        
        // إذا لم يكن في السعودية، حاول مرة أخرى
        if (attempt < maxRetries) {
          await Future.delayed(const Duration(seconds: 2));
          _error = 'جاري إعادة المحاولة لتحديد الموقع في السعودية... ($attempt/$maxRetries)';
          _safeNotifyListeners();
        }
      } catch (e) {
        if (attempt == maxRetries) {
          _error = 'فشل تحديد الموقع بعد $maxRetries محاولات: $e';
          _safeNotifyListeners();
        }
      }
    }
  }

  // ✅ التحقق من أن الموقع في السعودية
  bool _isLocationInSaudiArabia(double lat, double lng) {
    // الإحداثيات التقريبية للمملكة العربية السعودية
    const double minLat = 16.0;   // أقصى جنوب
    const double maxLat = 32.0;   // أقصى شمال
    const double minLng = 34.0;   // أقصى غرب
    const double maxLng = 55.0;   // أقصى شرق
    
    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }

  // دالة مبسطة لطلب الصلاحيات فقط
  Future<bool> requestLocationPermission() async {
    try {
      await _checkAndRequestPermission();
      return _locationPermission == LocationPermission.whileInUse || 
             _locationPermission == LocationPermission.always;
    } catch (e) {
      _error = 'خطأ في طلب صلاحيات الموقع: $e';
      _safeNotifyListeners();
      return false;
    }
  }

  // ✅ التحديث النهائي للإصدار 14.0.2
  Stream<Position> getLocationStream() {
    try {
      if (_locationPermission != LocationPermission.whileInUse &&
          _locationPermission != LocationPermission.always) {
        throw Exception('صلاحيات الموقع غير ممنوحة');
      }

      if (!_locationServiceEnabled) {
        throw Exception('خدمة الموقع غير مفعلة');
      }

      // ✅ الكود الصحيح للإصدار 14.0.2
      return Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 10,
        ),
      ).handleError((error) {
        _error = 'خطأ في تتبع الموقع: $error';
        _safeNotifyListeners();
        throw error;
      });
      
    } catch (e) {
      _error = 'تعذر بدء تتبع الموقع: $e';
      _safeNotifyListeners();
      return Stream.error(e);
    }
  }

  // دالة مساعدة لتحديث الموقع من الـ stream
  Future<void> _updateCurrentLocationFromPosition(Position position) async {
    try {
      // ✅ التحقق من الموقع في السعودية أولاً
      if (!_isLocationInSaudiArabia(position.latitude, position.longitude)) {
        return;
      }

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        final String address = _buildAddress(placemark);

        final newLocation = LocationModel(
          lat: position.latitude,
          lng: position.longitude,
          address: address,
          lastUpdated: DateTime.now(),
        );

        _currentLocation = newLocation;
        _addToRecentLocations(newLocation);
        _safeNotifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطأ في تحديث العنوان: $e');
      }
    }
  }

  // الحصول على آخر موقع معروف
  Future<void> getLastKnownPosition() async {
    try {
      final Position? position = await Geolocator.getLastKnownPosition();
      if (position != null && _isLocationInSaudiArabia(position.latitude, position.longitude)) {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark placemark = placemarks.first;
          final String address = _buildAddress(placemark);

          _currentLocation = LocationModel(
            lat: position.latitude,
            lng: position.longitude,
            address: address,
            lastUpdated: DateTime.now(),
          );
          _safeNotifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطأ في الحصول على آخر موقع معروف: $e');
      }
    }
  }

  Future<LocationModel> getLocationFromAddress(String address) async {
    if (_isLoading) throw Exception('عملية جارية بالفعل');
    
    _isLoading = true;
    _error = '';
    _safeNotifyListeners();

    try {
      final List<Location> locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        throw Exception('لم يتم العثور على العنوان');
      }

      final Location location = locations.first;
      
      // ✅ التحقق من أن الموقع في السعودية
      if (!_isLocationInSaudiArabia(location.latitude, location.longitude)) {
        throw 'العنوان المطلوب خارج المملكة العربية السعودية';
      }

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('لم يتم العثور على تفاصيل العنوان');
      }

      final Placemark placemark = placemarks.first;
      final String fullAddress = _buildAddress(placemark);

      final LocationModel locationModel = LocationModel(
        lat: location.latitude,
        lng: location.longitude,
        address: fullAddress,
        lastUpdated: DateTime.now(),
      );

      _addToRecentLocations(locationModel);
      _isLoading = false;
      _safeNotifyListeners();
      
      return locationModel;
      
    } catch (e) {
      _isLoading = false;
      _error = 'خطأ في الحصول على الإحداثيات: $e';
      _safeNotifyListeners();
      rethrow;
    }
  }

  String _buildAddress(Placemark placemark) {
    final List<String> addressParts = [];
    
    if (placemark.street?.isNotEmpty == true) addressParts.add(placemark.street!);
    if (placemark.subLocality?.isNotEmpty == true) addressParts.add(placemark.subLocality!);
    if (placemark.locality?.isNotEmpty == true) addressParts.add(placemark.locality!);
    if (placemark.administrativeArea?.isNotEmpty == true) addressParts.add(placemark.administrativeArea!);
    if (placemark.country?.isNotEmpty == true) addressParts.add(placemark.country!);

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'عنوان غير معروف';
  }

  // ✅ إضافة دالة _addToRecentLocations هنا
  void _addToRecentLocations(LocationModel location) {
    // إزالة إذا كان موجوداً مسبقاً
    _recentLocations.removeWhere((loc) => 
      loc.lat == location.lat && loc.lng == location.lng);
    
    // إضافة في البداية
    _recentLocations.insert(0, location);
    
    // الاحتفاظ بـ 10 مواقع فقط
    if (_recentLocations.length > 10) {
      _recentLocations = _recentLocations.sublist(0, 10);
    }
    
    _safeNotifyListeners();
  }

  // ✅ جعل الدالة public لتستخدم من الخارج
  void addToRecentLocations(LocationModel location) {
    _addToRecentLocations(location);
  }

  void setCurrentLocation(LocationModel location) {
    _currentLocation = location;
    _addToRecentLocations(location);
    _safeNotifyListeners();
  }

  void clearError() {
    if (_error.isNotEmpty) {
      _error = '';
      _safeNotifyListeners();
    }
  }

  void clearRecentLocations() {
    if (_recentLocations.isNotEmpty) {
      _recentLocations.clear();
      _safeNotifyListeners();
    }
  }

  // فتح إعدادات الموقع
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // فتح إعدادات التطبيق لتفعيل الصلاحيات
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // ✅ دالة جديدة: استخدام موقع افتراضي في السعودية
  void useDefaultSaudiLocation() {
    final defaultLocation = LocationModel(
      lat: 24.7136, // الرياض
      lng: 46.6753,
      address: 'الرياض، المملكة العربية السعودية',
      lastUpdated: DateTime.now(),
    );

    _currentLocation = defaultLocation;
    _addToRecentLocations(defaultLocation);
    _error = '';
    _safeNotifyListeners();
  }

  // ✅ دالة جديدة: التحقق من توفر خدمة الموقع والصلاحيات
  Future<bool> checkLocationAvailability() async {
    try {
      _locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_locationServiceEnabled) return false;

      await _checkAndRequestPermission();
      return _locationPermission == LocationPermission.whileInUse || 
             _locationPermission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  // إضافة دالة للتوقف عن التتبع
  void disposeProvider() {
    // يمكن إضافة أي تنظيفات ضرورية هنا
  }
}