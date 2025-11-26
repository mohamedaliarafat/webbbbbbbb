import 'package:customer/data/datasources/remote_datasource.dart';

import '../models/payment_model.dart';

class PaymentRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  Future<void> uploadPaymentProof({
    required String orderId,
    required String orderType,
    required Map<String, dynamic> paymentData,
  }) async {
    try {
      final response = await _remoteDataSource.post(
        '/payments/$orderType/$orderId/upload-proof',
        paymentData,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Upload payment proof failed');
      }
    } catch (e) {
      throw Exception('Upload payment proof error: $e');
    }
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String status,
    String? adminNotes,
  }) async {
    try {
      final response = await _remoteDataSource.patch(
        '/payments/$paymentId/verify',
        {
          'status': status,
          if (adminNotes != null) 'adminNotes': adminNotes,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Verify payment failed');
      }
    } catch (e) {
      throw Exception('Verify payment error: $e');
    }
  }

  Future<List<PaymentModel>> getPayments({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) queryParams['status'] = status;

      final response = await _remoteDataSource.get(
        '/payments',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List payments = response['payments'] ?? [];
        return payments.map((payment) => PaymentModel.fromJson(payment)).toList();
      } else {
        throw Exception(response['error'] ?? 'Get payments failed');
      }
    } catch (e) {
      throw Exception('Get payments error: $e');
    }
  }

  Future<PaymentModel> getPayment(String paymentId) async {
    try {
      final response = await _remoteDataSource.get('/payments/$paymentId');

      if (response['success'] == true) {
        return PaymentModel.fromJson(response['payment']);
      } else {
        throw Exception(response['error'] ?? 'Get payment failed');
      }
    } catch (e) {
      throw Exception('Get payment error: $e');
    }
  }
}