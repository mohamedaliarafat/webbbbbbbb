import 'package:customer/data/models/location_model.dart';
import 'package:customer/presentation/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(LocationModel) onLocationSelected;
  final String? initialAddress;

  const LocationPickerScreen({
    Key? key,
    required this.onLocationSelected,
    this.initialAddress,
  }) : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isGettingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    final locationProvider = context.read<LocationProvider>();
    
    if (locationProvider.currentLocation != null) {
      _setSelectedLocation(
        LatLng(
          locationProvider.currentLocation!.lat,
          locationProvider.currentLocation!.lng,
        ),
        locationProvider.currentLocation!.address,
      );
    } else {
      await _getCurrentLocation();
    }
  }

  void _setSelectedLocation(LatLng location, String address) {
    setState(() {
      _selectedLocation = location;
      _selectedAddress = address;
    });

    // تحريك الخريطة للموقع المحدد
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 16),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng latLng) async {
    await _getAddressFromCoordinates(latLng);
  }

  Future<void> _getAddressFromCoordinates(LatLng latLng) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        final String address = _buildDetailedAddress(placemark);

        setState(() {
          _selectedLocation = latLng;
          _selectedAddress = address;
          _isLoading = false;
        });

        // إضافة إلى المواقع الحديثة
        final locationModel = LocationModel(
          lat: latLng.latitude,
          lng: latLng.longitude,
          address: address,
          lastUpdated: DateTime.now(),
        );
        
       final locationProvider = context.read<LocationProvider>();
      locationProvider.addToRecentLocations(locationModel); // ✅ صحيح
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ في الحصول على العنوان: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSearch() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final locationProvider = context.read<LocationProvider>();
      final location = await locationProvider.getLocationFromAddress(
        _searchController.text.trim(),
      );

      _setSelectedLocation(
        LatLng(location.lat, location.lng),
        location.address,
      );

      setState(() {
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ لم يتم العثور على العنوان: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingCurrentLocation = true;
    });

    try {
      final locationProvider = context.read<LocationProvider>();
      
      // التحقق من الصلاحيات أولاً
      final hasPermission = await locationProvider.requestLocationPermission();
      
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يجب منح صلاحيات الموقع أولاً'),
            action: SnackBarAction(
              label: 'الإعدادات',
              onPressed: () => locationProvider.openAppSettings(),
            ),
          ),
        );
        setState(() {
          _isGettingCurrentLocation = false;
        });
        return;
      }

      await locationProvider.getCurrentLocation();

      if (locationProvider.currentLocation != null) {
        _setSelectedLocation(
          LatLng(
            locationProvider.currentLocation!.lat,
            locationProvider.currentLocation!.lng,
          ),
          locationProvider.currentLocation!.address,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم تحديد موقعك بدقة'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() {
        _isGettingCurrentLocation = false;
      });
    } catch (e) {
      setState(() {
        _isGettingCurrentLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ في الحصول على الموقع الحالي: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onConfirmLocation() {
    if (_selectedLocation != null && _selectedAddress != null) {
      final locationModel = LocationModel(
        lat: _selectedLocation!.latitude,
        lng: _selectedLocation!.longitude,
        address: _selectedAddress!,
        lastUpdated: DateTime.now(),
      );

      widget.onLocationSelected(locationModel);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ يرجى تحديد موقع أولاً'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _buildDetailedAddress(Placemark placemark) {
    final List<String> addressParts = [];
    
    // الشارع ورقم المبنى
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    
    // الحي
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      addressParts.add(placemark.subLocality!);
    }
    
    // المنطقة
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    
    // المدينة
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }
    
    // الدولة
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      addressParts.add(placemark.country!);
    }

    return addressParts.join(', ');
  }

  // دالة لتحليل العنوان إلى أجزاء مفصلة
  Map<String, String> _parseAddressDetails(Placemark placemark) {
    return {
      'street': placemark.street ?? '',
      'subLocality': placemark.subLocality ?? '',
      'locality': placemark.locality ?? '',
      'administrativeArea': placemark.administrativeArea ?? '',
      'country': placemark.country ?? '',
      'postalCode': placemark.postalCode ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('اختيار الموقع'),
        actions: [
          IconButton(
            icon: _isGettingCurrentLocation
                ? CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : Icon(Icons.my_location),
            onPressed: _isGettingCurrentLocation ? null : _getCurrentLocation,
            tooltip: 'الموقع الحالي',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن عنوان...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                SizedBox(width: 8),
                _isSearching
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _onSearch,
                        tooltip: 'بحث',
                      ),
              ],
            ),
          ),

          // العنوان المحدد
          if (_selectedAddress != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border(
                  bottom: BorderSide(color: Colors.green[100]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'الموقع المحدد:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    _selectedAddress!,
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 14,
                    ),
                  ),
                  if (_selectedLocation != null) ...[
                    SizedBox(height: 4),
                    Text(
                      'الإحداثيات: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // الخريطة
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? 
                        LatLng(24.7136, 46.6753), // الرياض كموقع افتراضي
                    zoom: 12,
                  ),
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: MarkerId('selected_location'),
                            position: _selectedLocation!,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed,
                            ),
                            infoWindow: InfoWindow(
                              title: 'الموقع المحدد',
                              snippet: _selectedAddress,
                            ),
                          ),
                        }
                      : {},
                ),

                // زر الموقع الحالي
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _isGettingCurrentLocation ? null : _getCurrentLocation,
                    child: _isGettingCurrentLocation
                        ? CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                        : Icon(Icons.my_location),
                    tooltip: 'الموقع الحالي',
                  ),
                ),

                // مؤشر التحميل
                if (_isLoading)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('جاري تحديد العنوان...'),
                        ],
                      ),
                    ),
                  ),

                // مؤشر تحديد الموقع
                Center(
                  child: Icon(
                    Icons.location_pin,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // المواقع الحديثة
          if (locationProvider.recentLocations.isNotEmpty)
            Container(
              height: 100,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'المواقع الحديثة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: locationProvider.recentLocations.length,
                      itemBuilder: (context, index) {
                        final location = locationProvider.recentLocations[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              _setSelectedLocation(
                                LatLng(location.lat, location.lng),
                                location.address,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.history, size: 14, color: Colors.blue),
                                      SizedBox(width: 4),
                                      Text(
                                        'موقع سابق',
                                        style: TextStyle(fontSize: 10, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 120),
                                    child: Text(
                                      location.address.length > 25
                                          ? '${location.address.substring(0, 25)}...'
                                          : location.address,
                                      style: TextStyle(fontSize: 11),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // زر التأكيد
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _selectedLocation != null ? _onConfirmLocation : null,
                icon: Icon(Icons.check_circle),
                label: Text(
                  'تأكيد الموقع المحدد',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedLocation != null ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}