import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:customer/presentation/providers/user_provider.dart';
import 'package:customer/presentation/screens/auth/login_screen.dart';
import 'package:customer/presentation/screens/notifications/notifications_screen.dart';
import 'package:customer/presentation/screens/payment/payment_methods_screen.dart';
import 'package:customer/presentation/screens/profile/addresses_screen.dart';
import 'package:customer/presentation/screens/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'العربية';

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            _buildUserProfileCard(authProvider, userProvider),
            SizedBox(height: 24),

            // Account Settings
            _buildSectionTitle('إعدادات الحساب'),
            _buildSettingsCard([
              _buildSettingsItem(
                icon: Icons.person_outline,
                title: 'الملف الشخصي',
                subtitle: 'إدارة معلومات حسابك',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()),
                  );
                },
              ),
              _buildSettingsItem(
                icon: Icons.location_on_outlined,
                title: 'العناوين',
                subtitle: 'إدارة عناوين التوصيل',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressesScreen()),
                  );
                },
              ),
              _buildSettingsItem(
                icon: Icons.payment_outlined,
                title: 'طرق الدفع',
                subtitle: 'إدارة طرق الدفع',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentMethodsScreen()),
                  );
                },
              ),
            ]),
            SizedBox(height: 24),

            // App Settings
            _buildSectionTitle('إعدادات التطبيق'),
            _buildSettingsCard([
              _buildSettingsItem(
                icon: Icons.notifications_outlined,
                title: 'الإشعارات',
                subtitle: 'إدارة الإشعارات',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsScreen()),
                  );
                },
              ),
              _buildSettingsItem(
                icon: Icons.dark_mode_outlined,
                title: 'الوضع الليلي',
                subtitle: 'تفعيل الوضع المظلم',
                trailing: Switch(
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
              ),
              _buildSettingsItem(
                icon: Icons.language_outlined,
                title: 'اللغة',
                subtitle: _language,
                onTap: _showLanguageDialog,
              ),
            ]),
            SizedBox(height: 24),

            // Support & About
            _buildSectionTitle('الدعم والمساعدة'),
            _buildSettingsCard([
              _buildSettingsItem(
                icon: Icons.help_outline,
                title: 'الأسئلة الشائعة',
                subtitle: 'إجابات على الأسئلة المتكررة',
                onTap: _openFAQ,
              ),
              _buildSettingsItem(
                icon: Icons.support_agent_outlined,
                title: 'الدعم الفني',
                subtitle: 'اتصل بفريق الدعم',
                onTap: _contactSupport,
              ),
              _buildSettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                subtitle: 'اطلع على سياسة الخصوصية',
                onTap: _openPrivacyPolicy,
              ),
              _buildSettingsItem(
                icon: Icons.description_outlined,
                title: 'شروط الخدمة',
                subtitle: 'اطلع على شروط الاستخدام',
                onTap: _openTermsOfService,
              ),
              _buildSettingsItem(
                icon: Icons.info_outline,
                title: 'عن التطبيق',
                subtitle: 'إصدار 1.0.0',
                onTap: _showAboutDialog,
              ),
            ]),
            SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(authProvider),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(AuthProvider authProvider, UserProvider userProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                authProvider.user?.profileImage ?? 
                'https://via.placeholder.com/150',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.user?.name ?? 'مستخدم',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    authProvider.user?.phone ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(authProvider.user?.isVerified ?? false),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      authProvider.user?.isVerified == true ? 'موثق' : 'غير موثق',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(bool isVerified) {
    return isVerified ? Colors.green : Colors.orange;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        Divider(height: 1, indent: 56),
      ],
    );
  }

  Widget _buildLogoutButton(AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showLogoutConfirmation(authProvider),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'تسجيل الخروج',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('العربية', true),
            _buildLanguageOption('English', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _language = 'العربية';
              });
              Navigator.pop(context);
            },
            child: Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        setState(() {
          _language = language;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showLogoutConfirmation(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الخروج'),
        content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performLogout(authProvider);
            },
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(AuthProvider authProvider) async {
    try {
      await authProvider.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الخروج'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openFAQ() async {
    const url = 'https://example.com/faq';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showNotAvailableMessage();
    }
  }

  void _contactSupport() async {
    const email = 'support@example.com';
    const phone = '+966500000000';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الدعم الفني'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('البريد الإلكتروني: $email'),
            SizedBox(height: 8),
            Text('الهاتف: $phone'),
            SizedBox(height: 16),
            Text('ساعات العمل: 9 ص - 5 م'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final url = Uri(
                scheme: 'tel',
                path: phone,
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() async {
    const url = 'https://example.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showNotAvailableMessage();
    }
  }

  void _openTermsOfService() async {
    const url = 'https://example.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showNotAvailableMessage();
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('عن التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تطبيق الوقود والمنتجات', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('الإصدار: 1.0.0'),
            SizedBox(height: 8),
            Text('الباني: شركة التقنية المحدودة'),
            SizedBox(height: 8),
            Text('© 2024 جميع الحقوق محفوظة'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showNotAvailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('هذه الميزة غير متاحة حالياً'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}