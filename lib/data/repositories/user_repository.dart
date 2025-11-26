import 'package:customer/data/datasources/remote_datasource.dart';

import '../models/user_model.dart';
import '../models/complete_profile_model.dart';

class UserRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  Future<UserModel> getUser(String userId) async {
    try {
      final response = await _remoteDataSource.get('/users/$userId');

      if (response['success'] == true) {
        return UserModel.fromJson(response['user']);
      } else {
        throw Exception(response['error'] ?? 'Get user failed');
      }
    } catch (e) {
      throw Exception('Get user error: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updateData) async {
    try {
      final response = await _remoteDataSource.put(
        '/users/$userId',
        updateData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Update user failed');
      }
    } catch (e) {
      throw Exception('Update user error: $e');
    }
  }

  Future<List<UserModel>> getUsers({
    String? userType,
    bool? isActive,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (userType != null) queryParams['userType'] = userType;
      if (isActive != null) queryParams['isActive'] = isActive.toString();
      if (search != null) queryParams['search'] = search;

      final response = await _remoteDataSource.get(
        '/users',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List users = response['users'] ?? [];
        return users.map((user) => UserModel.fromJson(user)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get users failed');
      }
    } catch (e) {
      throw Exception('Get users error: $e');
    }
  }

  Future<void> manageDriver(String driverId, String action, {String? reason}) async {
    try {
      final response = await _remoteDataSource.patch(
        '/users/drivers/manage',
        {
          'driverId': driverId,
          'action': action,
          'data': reason != null ? {'reason': reason} : null,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Manage driver failed');
      }
    } catch (e) {
      throw Exception('Manage driver error: $e');
    }
  }

  Future<void> approveProfile(String userId, String status, {String? rejectionReason}) async {
    try {
      final response = await _remoteDataSource.patch(
        '/users/$userId/approve-profile',
        {
          'status': status,
          if (rejectionReason != null) 'rejectionReason': rejectionReason,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Approve profile failed');
      }
    } catch (e) {
      throw Exception('Approve profile error: $e');
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _remoteDataSource.get('/users/stats');

      if (response['success'] == true) {
        return response['stats'] ?? {};
      } else {
        throw Exception(response['error'] ?? 'Get user stats failed');
      }
    } catch (e) {
      throw Exception('Get user stats error: $e');
    }
  }

  Future<CompleteProfileModel> getCompleteProfile(String userId) async {
    try {
      final user = await getUser(userId);
      if (user.completeProfile == null) {
        throw Exception('User does not have a complete profile');
      }

      // Note: This would typically come from a separate endpoint
      // For now, we'll return a mock or handle it differently
      throw Exception('Complete profile endpoint not implemented');
    } catch (e) {
      throw Exception('Get complete profile error: $e');
    }
  }
}