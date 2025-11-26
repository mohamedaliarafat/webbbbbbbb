import 'package:customer/data/models/payment_model.dart';
import 'package:flutter/material.dart';


class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback? onTap;
  final bool showStatus;
  final bool showActions;

  const PaymentCard({
    Key? key,
    required this.payment,
    this.onTap,
    this.showStatus = true,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Payment Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'دفعة #${_getShortId(payment.id)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'طلب #${_getShortId(payment.orderId)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${payment.totalAmount.toStringAsFixed(2)} ${payment.currency}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getAmountColor(),
                        ),
                      ),
                      SizedBox(height: 4),
                      if (showStatus)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor().withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getStatusText(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Bank Transfer Info
              if (payment.bankTransfer.bankName.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.account_balance,
                  title: 'البنك',
                  value: payment.bankTransfer.bankName,
                ),

              if (payment.bankTransfer.referenceNumber.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.receipt,
                  title: 'رقم المرجع',
                  value: payment.bankTransfer.referenceNumber,
                ),

              _buildInfoRow(
                icon: Icons.calendar_today,
                title: 'تاريخ الدفع',
                value: _formatDate(payment.paymentInitiatedAt!),
              ),

              // Payment Method
              _buildInfoRow(
                icon: _getPaymentMethodIcon(),
                title: 'طريقة الدفع',
                value: _getPaymentMethodText(),
              ),

              // Actions (if needed)
              if (showActions && _shouldShowActions())
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Row(
                    children: _buildActionButtons(),
                  ),
                ),

              // Admin Notes (if exists and status is rejected)
              if (payment.adminNotes!.isNotEmpty && payment.status == 'rejected')
                Container(
                  margin: EdgeInsets.only(top: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          payment.adminNotes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8),
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final buttons = <Widget>[];

    if (payment.status == 'waiting_proof') {
      buttons.addAll([
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Upload proof action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('رفع إثبات الدفع'),
          ),
        ),
        SizedBox(width: 8),
      ]);
    }

    if (payment.status == 'under_review') {
      buttons.addAll([
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // View details action
            },
            child: Text('عرض التفاصيل'),
          ),
        ),
        SizedBox(width: 8),
      ]);
    }

    if (payment.status == 'rejected') {
      buttons.addAll([
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Retry payment action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('إعادة المحاولة'),
          ),
        ),
        SizedBox(width: 8),
      ]);
    }

    // Always show details button
    buttons.add(
      Expanded(
        child: OutlinedButton(
          onPressed: onTap,
          child: Text('التفاصيل'),
        ),
      ),
    );

    return buttons;
  }

  bool _shouldShowActions() {
    return payment.status == 'waiting_proof' ||
        payment.status == 'under_review' ||
        payment.status == 'rejected';
  }

  Color _getAmountColor() {
    switch (payment.status) {
      case 'verified':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'failed':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor() {
    switch (payment.status) {
      case 'verified':
        return Colors.green;
      case 'under_review':
        return Colors.orange;
      case 'waiting_proof':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'failed':
        return Colors.red;
      case 'hidden':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (payment.status) {
      case 'verified':
        return 'تم التحقق';
      case 'under_review':
        return 'قيد المراجعة';
      case 'waiting_proof':
        return 'بانتظار الإثبات';
      case 'rejected':
        return 'مرفوض';
      case 'failed':
        return 'فشل';
      case 'hidden':
        return 'مخفي';
      default:
        return payment.status;
    }
  }

  IconData _getPaymentMethodIcon() {
    switch (payment.paymentMethod) {
      case 'bank_transfer':
        return Icons.account_balance;
      case 'mada':
        return Icons.credit_card;
      case 'apple_pay':
        return Icons.apple;
      case 'google_pay':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodText() {
    switch (payment.paymentMethod) {
      case 'bank_transfer':
        return 'تحويل بنكي';
      case 'mada':
        return 'مدى';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      default:
        return payment.paymentMethod;
    }
  }

  String _getShortId(String id) {
    if (id.length > 8) {
      return '${id.substring(0, 4)}...${id.substring(id.length - 4)}';
    }
    return id;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Payment Card for List View (Compact Version)
class CompactPaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback onTap;

  const CompactPaymentCard({
    Key? key,
    required this.payment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getPaymentMethodIcon(),
            color: _getStatusColor(),
            size: 20,
          ),
        ),
        title: Text(
          '${payment.totalAmount.toStringAsFixed(2)} ${payment.currency}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getAmountColor(),
          ),
        ),
        subtitle: Text(
          'طلب #${_getShortId(payment.orderId)}',
          style: TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(),
              ),
            ),
            Text(
              _formatDate(payment.paymentInitiatedAt!),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor() {
    switch (payment.status) {
      case 'verified':
        return Colors.green;
      case 'under_review':
        return Colors.orange;
      case 'waiting_proof':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getAmountColor() {
    switch (payment.status) {
      case 'verified':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getStatusText() {
    switch (payment.status) {
      case 'verified':
        return 'تم التحقق';
      case 'under_review':
        return 'قيد المراجعة';
      case 'waiting_proof':
        return 'بانتظار الإثبات';
      case 'rejected':
        return 'مرفوض';
      default:
        return payment.status;
    }
  }

  IconData _getPaymentMethodIcon() {
    switch (payment.paymentMethod) {
      case 'bank_transfer':
        return Icons.account_balance;
      case 'mada':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  String _getShortId(String id) {
    if (id.length > 8) {
      return '${id.substring(0, 4)}...${id.substring(id.length - 4)}';
    }
    return id;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Payment Status Badge Widget (Reusable)
class PaymentStatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const PaymentStatusBadge({
    Key? key,
    required this.status,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact 
          ? EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
        ),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case 'verified':
        return Colors.green;
      case 'under_review':
        return Colors.orange;
      case 'waiting_proof':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'failed':
        return Colors.red;
      case 'hidden':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'verified':
        return 'تم التحقق';
      case 'under_review':
        return 'قيد المراجعة';
      case 'waiting_proof':
        return 'بانتظار الإثبات';
      case 'rejected':
        return 'مرفوض';
      case 'failed':
        return 'فشل';
      case 'hidden':
        return 'مخفي';
      default:
        return status;
    }
  }
}