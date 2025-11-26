import 'package:customer/data/models/complete_profile_model.dart';
import 'package:customer/data/models/user_model.dart';
import 'package:customer/data/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';


class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  UserModel? _currentUser;
  List<UserModel> _users = [];
  CompleteProfileModel? _completeProfile;
  bool _isLoading = false;
  String _error = '';

  UserModel? get currentUser => _currentUser;
  List<UserModel> get users => _users;
  CompleteProfileModel? get completeProfile => _completeProfile;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadUser(String userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currentUser = await _userRepository.getUser(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updateData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _userRepository.updateUser(userId, updateData);
      if (_currentUser != null && _currentUser!.id == userId) {
        _currentUser = _currentUser!.copyWith(
          name: updateData['name'] ?? _currentUser!.name,
          phone: updateData['phone'] ?? _currentUser!.phone,
          profileImage: updateData['profileImage'] ?? _currentUser!.profileImage,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadUsers({
    String? userType,
    bool? isActive,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _users = await _userRepository.getUsers(
        userType: userType,
        isActive: isActive,
        search: search,
        page: page,
        limit: limit,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> manageDriver(String driverId, String action, {String? reason}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _userRepository.manageDriver(driverId, action, reason: reason);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> approveProfile(String userId, String status, {String? rejectionReason}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _userRepository.approveProfile(userId, status, rejectionReason: rejectionReason);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final stats = await _userRepository.getUserStats();
      _isLoading = false;
      notifyListeners();
      return stats;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return {};
    }
  }

  Future<void> loadCompleteProfile(String userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _completeProfile = await _userRepository.getCompleteProfile(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void clearUsers() {
    _users = [];
    notifyListeners();
  }
}