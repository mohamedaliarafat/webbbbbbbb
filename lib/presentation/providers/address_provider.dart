// import 'package:customer/data/models/address_model.dart';
// import 'package:customer/data/models/location_model.dart';
// import 'package:customer/data/repositories/address_repository.dart';
// import 'package:flutter/foundation.dart';


// class AddressProvider with ChangeNotifier {
//   final AddressRepository _addressRepository = AddressRepository();
  
//   List<AddressModel> _addresses = [];
//   AddressModel? _selectedAddress;
//   AddressModel? _defaultAddress;
//   bool _isLoading = false;
//   String _error = '';

//   List<AddressModel> get addresses => _addresses;
//   AddressModel? get selectedAddress => _selectedAddress;
//   AddressModel? get defaultAddress => _defaultAddress;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   Future<void> loadAddresses({bool? isDefault}) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       _addresses = await _addressRepository.getUserAddresses(isDefault: isDefault);
//       _defaultAddress = _addresses.firstWhere(
//         (address) => address.isDefault,
//         orElse: () => _addresses.isNotEmpty ? _addresses.first : AddressModel(
//           id: '',
//           userId: '',
//           addressLine1: '',
//           addressLine2: '',
//           city: '',
//           district: '',
//           state: '',
//           country: '',
//           postalCode: '',
//           addressType: 'home',
//           contactName: '',
//           contactPhone: '',
//           coordinates: LocationModel(lat: 0, lng: 0, address: ''),
//           deliveryInstructions: '',
//           isDefault: false,
//           isActive: true,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//       );
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final address = await _addressRepository.createAddress(addressData);
//       _addresses.add(address);
      
//       if (address.isDefault) {
//         _setDefaultAddress(address);
//       }
      
//       _isLoading = false;
//       notifyListeners();
//       return address;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       rethrow;
//     }
//   }

//   Future<AddressModel> updateAddress(String addressId, Map<String, dynamic> updateData) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final address = await _addressRepository.updateAddress(addressId, updateData);
      
//       // Update local state
//       final index = _addresses.indexWhere((addr) => addr.id == addressId);
//       if (index != -1) {
//         _addresses[index] = address;
//       }
      
//       if (address.isDefault) {
//         _setDefaultAddress(address);
//       }
      
//       if (_selectedAddress?.id == addressId) {
//         _selectedAddress = address;
//       }
      
//       _isLoading = false;
//       notifyListeners();
//       return address;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       rethrow;
//     }
//   }

//   Future<void> deleteAddress(String addressId) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       await _addressRepository.deleteAddress(addressId);
      
//       // Remove from local state
//       _addresses.removeWhere((addr) => addr.id == addressId);
      
//       if (_selectedAddress?.id == addressId) {
//         _selectedAddress = null;
//       }
      
//       if (_defaultAddress?.id == addressId) {
//         _defaultAddress = _addresses.isNotEmpty ? _addresses.first : null;
//       }
      
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   Future<AddressModel> setDefaultAddress(String addressId) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final address = await _addressRepository.setDefaultAddress(addressId);
//       _setDefaultAddress(address);
//       _isLoading = false;
//       notifyListeners();
//       return address;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       rethrow;
//     }
//   }

//   void _setDefaultAddress(AddressModel address) {
//     // Remove default from all addresses
//     for (var addr in _addresses) {
//       if (addr.id == address.id) {
//         _addresses[_addresses.indexWhere((a) => a.id == addr.id)] = address;
//       } else if (addr.isDefault) {
//         _addresses[_addresses.indexWhere((a) => a.id == addr.id)] = addr.copyWith(isDefault: false);
//       }
//     }
    
//     _defaultAddress = address;
//   }

//   void setSelectedAddress(AddressModel address) {
//     _selectedAddress = address;
//     notifyListeners();
//   }

//   void clearSelectedAddress() {
//     _selectedAddress = null;
//     notifyListeners();
//   }

//   void clearError() {
//     _error = '';
//     notifyListeners();
//   }

//   void clearAddresses() {
//     _addresses = [];
//     _selectedAddress = null;
//     _defaultAddress = null;
//     notifyListeners();
//   }
// }



import 'package:customer/data/models/address_model.dart';
import 'package:customer/data/models/location_model.dart';
import 'package:customer/data/repositories/address_repository.dart';
import 'package:flutter/foundation.dart';

class AddressProvider with ChangeNotifier {
  final AddressRepository _addressRepository = AddressRepository();
  
  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;
  AddressModel? _defaultAddress;
  bool _isLoading = false;
  String _error = '';

  List<AddressModel> get addresses => List.unmodifiable(_addresses);
  AddressModel? get selectedAddress => _selectedAddress;
  AddressModel? get defaultAddress => _defaultAddress;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadAddresses({bool? isDefault}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _addresses = await _addressRepository.getUserAddresses(isDefault: isDefault);
      _findDefaultAddress();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ✅ دالة مساعدة للعثور على العنوان الافتراضي
  void _findDefaultAddress() {
    try {
      _defaultAddress = _addresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => _addresses.isNotEmpty ? _addresses.first : _createEmptyAddress(),
      );
    } catch (e) {
      _defaultAddress = _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // ✅ دالة مساعدة لإنشاء عنوان فارغ
  AddressModel _createEmptyAddress() {
    return AddressModel(
      id: '',
      userId: '',
      addressLine1: '',
      addressLine2: '',
      city: '',
      district: '',
      state: '',
      country: '',
      postalCode: '',
      addressType: 'home',
      contactName: '',
      contactPhone: '',
      coordinates: LocationModel(lat: 0, lng: 0, address: ''),
      deliveryInstructions: '',
      isDefault: false,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final address = await _addressRepository.createAddress(addressData);
      _addresses.add(address);
      
      if (address.isDefault) {
        _setDefaultAddress(address);
      }
      
      _isLoading = false;
      notifyListeners();
      return address;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<AddressModel> updateAddress(String addressId, Map<String, dynamic> updateData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final address = await _addressRepository.updateAddress(addressId, updateData);
      
      // ✅ تحديث الحالة المحلية مع تحسين الأداء
      final index = _addresses.indexWhere((addr) => addr.id == addressId);
      if (index != -1) {
        _addresses[index] = address;
      } else {
        _addresses.add(address); // إذا لم يكن موجوداً، أضفه
      }
      
      if (address.isDefault) {
        _setDefaultAddress(address);
      }
      
      if (_selectedAddress?.id == addressId) {
        _selectedAddress = address;
      }
      
      _isLoading = false;
      notifyListeners();
      return address;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _addressRepository.deleteAddress(addressId);
      
      // ✅ إزالة من الحالة المحلية
      _addresses.removeWhere((addr) => addr.id == addressId);
      
      if (_selectedAddress?.id == addressId) {
        _selectedAddress = null;
      }
      
      if (_defaultAddress?.id == addressId) {
        _findDefaultAddress(); // إعادة البحث عن العنوان الافتراضي
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<AddressModel> setDefaultAddress(String addressId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final address = await _addressRepository.setDefaultAddress(addressId);
      _setDefaultAddress(address);
      _isLoading = false;
      notifyListeners();
      return address;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ✅ تحسين دالة تعيين العنوان الافتراضي
  void _setDefaultAddress(AddressModel address) {
    // إزالة الوضع الافتراضي من جميع العناوين
    _addresses = _addresses.map((addr) {
      if (addr.id == address.id) {
        return address; // العنوان الجديد الافتراضي
      } else if (addr.isDefault) {
        return addr.copyWith(isDefault: false); // إزالة الافتراضي من الآخرين
      }
      return addr;
    }).toList();
    
    _defaultAddress = address;
  }

  // ✅ دالة مساعدة للبحث عن عنوان بالمعرف
  AddressModel? getAddressById(String addressId) {
    try {
      return _addresses.firstWhere((addr) => addr.id == addressId);
    } catch (e) {
      return null;
    }
  }

  // ✅ دالة لتعيين العنوان المحدد بالمعرف
  void setSelectedAddressById(String addressId) {
    final address = getAddressById(addressId);
    if (address != null) {
      _selectedAddress = address;
      notifyListeners();
    }
  }

  void setSelectedAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void clearSelectedAddress() {
    _selectedAddress = null;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void clearAddresses() {
    _addresses = [];
    _selectedAddress = null;
    _defaultAddress = null;
    notifyListeners();
  }

  // ✅ دالة للتحقق من وجود عناوين
  bool get hasAddresses => _addresses.isNotEmpty;

  // ✅ دالة للحصول على عدد العناوين
  int get addressesCount => _addresses.length;

  // ✅ دالة لتحديث العنوان محلياً دون الاتصال بالخادم
  void updateAddressLocally(AddressModel updatedAddress) {
    final index = _addresses.indexWhere((addr) => addr.id == updatedAddress.id);
    if (index != -1) {
      _addresses[index] = updatedAddress;
      
      if (updatedAddress.isDefault) {
        _setDefaultAddress(updatedAddress);
      }
      
      if (_selectedAddress?.id == updatedAddress.id) {
        _selectedAddress = updatedAddress;
      }
      
      notifyListeners();
    }
  }
}