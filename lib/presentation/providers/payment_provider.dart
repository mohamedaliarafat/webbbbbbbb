
import 'package:customer/data/models/payment_model.dart';
import 'package:customer/data/repositories/payment_repository.dart';

import 'package:flutter/foundation.dart';


class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository = PaymentRepository();
  
  List<PaymentModel> _payments = [];
  PaymentModel? _selectedPayment;
  bool _isLoading = false;
  String _error = '';

  List<PaymentModel> get payments => _payments;
  PaymentModel? get selectedPayment => _selectedPayment;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadPayments({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _payments = await _paymentRepository.getPayments(
        status: status,
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

  Future<void> uploadPaymentProof({
    required String orderId,
    required String orderType,
    required Map<String, dynamic> paymentData,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _paymentRepository.uploadPaymentProof(
        orderId: orderId,
        orderType: orderType,
        paymentData: paymentData,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String status,
    String? adminNotes,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _paymentRepository.verifyPayment(
        paymentId: paymentId,
        status: status,
        adminNotes: adminNotes,
      );
      
      // Update local state
      final index = _payments.indexWhere((payment) => payment.id == paymentId);
      if (index != -1) {
        _payments[index] = PaymentModel(
          id: _payments[index].id,
          orderId: _payments[index].orderId,
          userId: _payments[index].userId,
          userName: _payments[index].userName,
          totalAmount: _payments[index].totalAmount,
          currency: _payments[index].currency,
          bankTransfer: _payments[index].bankTransfer,
          receipt: _payments[index].receipt,
          status: status,
          reviewedBy: _payments[index].reviewedBy,
          reviewedAt: _payments[index].reviewedAt,
          rejectionReason: _payments[index].rejectionReason,
          adminNotes: adminNotes ?? _payments[index].adminNotes,
          customerNotes: _payments[index].customerNotes,
          paymentInitiatedAt: _payments[index].paymentInitiatedAt,
          proofSubmittedAt: _payments[index].proofSubmittedAt,
          verifiedAt: status == 'verified' ? DateTime.now() : _payments[index].verifiedAt,
          paymentMethod: _payments[index].paymentMethod,
          attemptCount: _payments[index].attemptCount,
          lastAttemptAt: _payments[index].lastAttemptAt,
          createdAt: _payments[index].createdAt,
          updatedAt: _payments[index].updatedAt,
        );
      }
      
      if (_selectedPayment?.id == paymentId) {
        _selectedPayment = _payments[index];
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadPayment(String paymentId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _selectedPayment = await _paymentRepository.getPayment(paymentId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void setSelectedPayment(PaymentModel payment) {
    _selectedPayment = payment;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void clearPayments() {
    _payments = [];
    _selectedPayment = null;
    notifyListeners();
  }
}