import 'package:customer/data/models/user_model.dart';
import 'package:customer/data/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  
  UserModel? _user;
  bool _isLoading = false;
  String _error = '';
  bool _isLoggedIn = false;
  bool _isCheckingAuth = false; // حالة التحقق من المصادقة

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get isCheckingAuth => _isCheckingAuth; // getter للحالة الجديدة

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isCheckingAuth = true;
    notifyListeners();

    try {
      _isLoggedIn = await _authRepository.isLoggedIn();
      if (_isLoggedIn) {
        await verifyToken();
      }
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _user = await _authRepository.login(phone, password);
      _isLoading = false;
      _isLoggedIn = true;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String phone, String password, String userType) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _user = await _authRepository.register(phone, password, userType);
      _isLoading = false;
      _isLoggedIn = true;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyPhone(String phone, String verificationCode) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.verifyPhone(phone, verificationCode);
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendVerification(String phone) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.resendVerification(phone);
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.completeProfile(profileData);
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadDocuments(Map<String, dynamic> documents) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.uploadDocuments(documents);
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyToken() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authRepository.verifyToken();
      _isLoading = false;
      _isLoggedIn = true;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _isLoggedIn = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.updateProfile(updateData);
      if (_user != null) {
        _user = _user!.copyWith(
          name: updateData['name'] ?? _user!.name,
          phone: updateData['phone'] ?? _user!.phone,
          profileImage: updateData['profileImage'] ?? _user!.profileImage,
        );
      }
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String phone) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.forgotPassword(phone);
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String phone, String newPassword, String resetCode) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authRepository.resetPassword(phone, newPassword, resetCode);
      _isLoading = false;
      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _user = null;
      _isLoggedIn = false;
      _error = '';
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}