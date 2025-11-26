// import 'package:customer/data/datasources/remote_datasource.dart';

// import '../models/address_model.dart';


// class AddressRepository {
//   final RemoteDataSource _remoteDataSource = RemoteDataSource();

//   Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
//     try {
//       final response = await _remoteDataSource.post('/addresses', addressData);

//       if (response['success'] == true) {
//         return AddressModel.fromJson(response['address']);
//       } else {
//         throw Exception(response['error'] ?? 'Create address failed');
//       }
//     } catch (e) {
//       throw Exception('Create address error: $e');
//     }
//   }

//   Future<List<AddressModel>> getUserAddresses({bool? isDefault}) async {
//     try {
//       final Map<String, dynamic> queryParams = {};
//       if (isDefault != null) queryParams['isDefault'] = isDefault.toString();

//       final response = await _remoteDataSource.get(
//         '/addresses',
//         queryParams: queryParams,
//       );

//       if (response['success'] == true) {
//         final List addresses = response['addresses'] ?? [];
//         return addresses.map((address) => AddressModel.fromJson(address)).toList();
//       } else {
//         throw Exception(response['error'] ?? 'Get addresses failed');
//       }
//     } catch (e) {
//       throw Exception('Get addresses error: $e');
//     }
//   }

//   Future<AddressModel> getAddress(String addressId) async {
//     try {
//       final response = await _remoteDataSource.get('/addresses/$addressId');

//       if (response['success'] == true) {
//         return AddressModel.fromJson(response['address']);
//       } else {
//         throw Exception(response['error'] ?? 'Get address failed');
//       }
//     } catch (e) {
//       throw Exception('Get address error: $e');
//     }
//   }

//   Future<AddressModel> updateAddress(String addressId, Map<String, dynamic> updateData) async {
//     try {
//       final response = await _remoteDataSource.put(
//         '/addresses/$addressId',
//         updateData,
//       );

//       if (response['success'] == true) {
//         return AddressModel.fromJson(response['address']);
//       } else {
//         throw Exception(response['error'] ?? 'Update address failed');
//       }
//     } catch (e) {
//       throw Exception('Update address error: $e');
//     }
//   }

//   Future<void> deleteAddress(String addressId) async {
//     try {
//       final response = await _remoteDataSource.delete('/addresses/$addressId');

//       if (response['success'] != true) {
//         throw Exception(response['error'] ?? 'Delete address failed');
//       }
//     } catch (e) {
//       throw Exception('Delete address error: $e');
//     }
//   }

//   Future<AddressModel> setDefaultAddress(String addressId) async {
//     try {
//       final response = await _remoteDataSource.patch(
//         '/addresses/$addressId/set-default',
//         {},
//       );

//       if (response['success'] == true) {
//         return AddressModel.fromJson(response['address']);
//       } else {
//         throw Exception(response['error'] ?? 'Set default address failed');
//       }
//     } catch (e) {
//       throw Exception('Set default address error: $e');
//     }
//   }
// }


import 'package:customer/data/datasources/remote_datasource.dart';
import '../models/address_model.dart';

class AddressRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  Future<AddressModel> createAddress(Map<String, dynamic> addressData) async {
    try {
      print('🎯 [AddressRepository] Creating address...');
      print('📦 Address data: $addressData');

      final response = await _remoteDataSource.post('/addresses', addressData);

      print('📥 [AddressRepository] Create address response: $response');

      // ✅ معالجة متعددة للأشكال المحتملة للاستجابة
      if (response['success'] == true) {
        if (response['address'] != null) {
          return AddressModel.fromJson(response['address']);
        } else if (response['data'] != null) {
          return AddressModel.fromJson(response['data']);
        } else {
          throw Exception('Success but no address data found in response');
        }
      } else if (response['id'] != null) {
        // إذا كانت الاستجابة تحتوي على id مباشرة (بدون success field)
        return AddressModel.fromJson(response);
      } else {
        final errorMessage = response['error'] ?? 
                           response['message'] ?? 
                           response['detail'] ?? 
                           'Create address failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ [AddressRepository] Create address error: $e');
      throw Exception('Create address error: $e');
    }
  }

  Future<List<AddressModel>> getUserAddresses({bool? isDefault}) async {
    try {
      print('🎯 [AddressRepository] Getting user addresses...');
      
      final Map<String, dynamic> queryParams = {};
      if (isDefault != null) {
        queryParams['isDefault'] = isDefault.toString();
      }

      final response = await _remoteDataSource.get(
        '/addresses',
        queryParams: queryParams,
      );

      print('📥 [AddressRepository] Get addresses response: $response');

      if (response['success'] == true) {
        final List addresses = response['addresses'] ?? response['data'] ?? [];
        // ✅ التصحيح: addresses هو List بالفعل، لذا يمكن استخدام map()
        return addresses.map((address) => AddressModel.fromJson(address)).toList();
      } else {
        final errorMessage = response['error'] ?? 
                           response['message'] ?? 
                           'Get addresses failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ [AddressRepository] Get addresses error: $e');
      throw Exception('Get addresses error: $e');
    }
  }

  Future<AddressModel> getAddress(String addressId) async {
    try {
      print('🎯 [AddressRepository] Getting address: $addressId');
      
      final response = await _remoteDataSource.get('/addresses/$addressId');

      print('📥 [AddressRepository] Get address response: $response');

      if (response['success'] == true) {
        if (response['address'] != null) {
          return AddressModel.fromJson(response['address']);
        } else if (response['data'] != null) {
          return AddressModel.fromJson(response['data']);
        } else {
          throw Exception('Success but no address data found');
        }
      } else if (response['id'] != null) {
        return AddressModel.fromJson(response);
      } else {
        final errorMessage = response['error'] ?? 
                           response['message'] ?? 
                           'Get address failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ [AddressRepository] Get address error: $e');
      throw Exception('Get address error: $e');
    }
  }

  Future<AddressModel> updateAddress(String addressId, Map<String, dynamic> updateData) async {
    try {
      print('🎯 [AddressRepository] Updating address: $addressId');
      print('📦 Update data: $updateData');

      final response = await _remoteDataSource.put(
        '/addresses/$addressId',
        updateData,
      );

      print('📥 [AddressRepository] Update address response: $response');

      if (response['success'] == true) {
        if (response['address'] != null) {
          return AddressModel.fromJson(response['address']);
        } else if (response['data'] != null) {
          return AddressModel.fromJson(response['data']);
        } else {
          throw Exception('Success but no address data found in response');
        }
      } else if (response['id'] != null) {
        return AddressModel.fromJson(response);
      } else {
        final errorMessage = response['error'] ?? 
                           response['message'] ?? 
                           'Update address failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ [AddressRepository] Update address error: $e');
      throw Exception('Update address error: $e');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      print('🎯 [AddressRepository] Deleting address: $addressId');
      
      final response = await _remoteDataSource.delete('/addresses/$addressId');

      print('📥 [AddressRepository] Delete address response: $response');

      if (response['success'] != true) {
        final errorMessage = response['error'] ?? 
                           response['message'] ?? 
                           'Delete address failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ [AddressRepository] Delete address error: $e');
      throw Exception('Delete address error: $e');
    }
  }

  Future<AddressModel> setDefaultAddress(String addressId) async {
    try {
      print('🎯 [AddressRepository] Setting default address: $addressId');
      
      final response = await _remoteDataSource.patch(
        '/addresses/$addressId/set-default',
        {},
      );

      print('📥 [AddressRepository] Set default address response: $response');

      if (response['success'] == true) {
        if (response['address'] != null) {
          return AddressModel.fromJson(response['address']);
        } else if (response['data'] != null) {
          return AddressModel.fromJson(response['data']);
        } else {
          throw Exception('Success but no address data found in response');
        }
      } else if (response['id'] != null) {
        return AddressModel.fromJson(response);
      } else {
        final errorMessage = response['error'] ?? 
                           response['message'] ?? 
                           'Set default address failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ [AddressRepository] Set default address error: $e');
      throw Exception('Set default address error: $e');
    }
  }
}