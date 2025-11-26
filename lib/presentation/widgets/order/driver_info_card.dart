import 'package:customer/data/models/user_model.dart';
import 'package:flutter/material.dart';


class DriverInfoCard extends StatelessWidget {
  final UserModel driver;
  final VoidCallback? onCallPressed;
  final VoidCallback? onChatPressed;
  final VoidCallback? onLocationPressed;

  const DriverInfoCard({
    Key? key,
    required this.driver,
    this.onCallPressed,
    this.onChatPressed,
    this.onLocationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  'معلومات السائق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // معلومات السائق
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصورة
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(driver.profileImage),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // المعلومات الأساسية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name.isNotEmpty ? driver.name : 'السائق',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        driver.phone,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),

                      // التقييم
                      _buildRatingSection(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // معلومات الموقع إذا كانت متاحة
            if (driver.location != null && driver.location!.address.isNotEmpty)
              _buildLocationInfo(),

            SizedBox(height: 16),

            // أزرار التواصل
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // النجوم
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 16,
              color: index < 4 ? Colors.amber : Colors.grey[300],
            );
          }),
        ),
        SizedBox(width: 8),
        Text(
          '4.8',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber[800],
          ),
        ),
        SizedBox(width: 4),
        Text(
          '(125 تقييم)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الموقع الحالي',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  driver.location!.address,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (driver.location!.lastUpdated != null)
                  Text(
                    'آخر تحديث: ${_formatTime(driver.location!.lastUpdated!)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
          if (onLocationPressed != null)
            IconButton(
              icon: Icon(
                Icons.directions,
                color: Colors.blue,
              ),
              onPressed: onLocationPressed,
              tooltip: 'فتح الخريطة',
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // زر المكالمة
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.phone, size: 18),
            label: Text('اتصال'),
            onPressed: onCallPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 8),

        // زر المحادثة
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.chat, size: 18),
            label: Text('محادثة'),
            onPressed: onChatPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

// نسخة مبسطة من البطاقة للاستخدام في الشاشات المدمجة
class CompactDriverInfoCard extends StatelessWidget {
  final UserModel driver;
  final VoidCallback? onCallPressed;
  final VoidCallback? onChatPressed;

  const CompactDriverInfoCard({
    Key? key,
    required this.driver,
    this.onCallPressed,
    this.onChatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // صورة السائق
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(driver.profileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),

            // المعلومات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name.isNotEmpty ? driver.name : 'السائق',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    driver.phone,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // أزرار التواصل
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.phone, size: 20),
                  color: Colors.green,
                  onPressed: onCallPressed,
                  tooltip: 'اتصال',
                ),
                IconButton(
                  icon: Icon(Icons.chat, size: 20),
                  color: Colors.blue,
                  onPressed: onChatPressed,
                  tooltip: 'محادثة',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// بطاقة السائق مع حالة التوصيل
class DriverInfoCardWithStatus extends StatelessWidget {
  final UserModel driver;
  final String deliveryStatus;
  final String estimatedTime;
  final VoidCallback? onCallPressed;
  final VoidCallback? onChatPressed;
  final VoidCallback? onTrackPressed;

  const DriverInfoCardWithStatus({
    Key? key,
    required this.driver,
    required this.deliveryStatus,
    required this.estimatedTime,
    this.onCallPressed,
    this.onChatPressed,
    this.onTrackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // رأس البطاقة مع الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  estimatedTime,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // معلومات السائق
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(driver.profileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name.isNotEmpty ? driver.name : 'السائق',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        driver.phone,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.phone, size: 18),
                    label: Text('اتصال'),
                    onPressed: onCallPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.chat, size: 18),
                    label: Text('محادثة'),
                    onPressed: onChatPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (onTrackPressed != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.location_on, size: 18),
                      label: Text('تتبع'),
                      onPressed: onTrackPressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (deliveryStatus.toLowerCase()) {
      case 'assigned_to_driver':
        return Icons.person;
      case 'on_the_way':
        return Icons.directions_car;
      case 'arrived':
        return Icons.location_on;
      case 'delivering':
        return Icons.local_shipping;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.pending;
    }
  }

  Color _getStatusColor() {
    switch (deliveryStatus.toLowerCase()) {
      case 'assigned_to_driver':
        return Colors.blue;
      case 'on_the_way':
        return Colors.orange;
      case 'arrived':
        return Colors.green;
      case 'delivering':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (deliveryStatus.toLowerCase()) {
      case 'assigned_to_driver':
        return 'تم تعيين السائق';
      case 'on_the_way':
        return 'في الطريق إليك';
      case 'arrived':
        return 'وصل للموقع';
      case 'delivering':
        return 'جاري التوصيل';
      case 'completed':
        return 'تم التسليم';
      default:
        return 'قيد المعالجة';
    }
  }
}