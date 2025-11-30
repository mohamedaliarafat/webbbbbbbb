import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userType = 'customer';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _fullPhoneNumber = '';

  late AnimationController _animationController;

  final List<Color> _colorList1 = [const Color(0xFF4B77BE), const Color(0xFF67B26F)];
  final List<Color> _colorList2 = [const Color(0xFF67B26F), const Color(0xFF4B77BE)];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    // أحجام ديناميكية
    final logoSize = isDesktop ? 250.0 : 150.0;
    final titleFontSize = isDesktop ? 40.0 : 28.0;
    final subtitleFontSize = isDesktop ? 20.0 : 16.0;
    final inputFontSize = isDesktop ? 18.0 : 14.0;
    final buttonFontSize = isDesktop ? 22.0 : 18.0;
    final spacing = isDesktop ? 30.0 : 20.0;

    final Color color1 = Color.lerp(_colorList1[0], _colorList2[0], _animationController.value)!;
    final Color color2 = Color.lerp(_colorList1[1], _colorList2[1], _animationController.value)!;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتحركة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color1.withOpacity(0.9),
                  color2.withOpacity(0.9),
                  Colors.white,
                ],
                stops: [0.0, 0.3 + (_animationController.value * 0.2), 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 500 : size.width),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: spacing),
                        // Logo
                        Image.asset(
                          'assets/images/logo.png',
                          height: logoSize,
                          width: logoSize,
                        ),
                        SizedBox(height: spacing / 2),

                        // عنوان إنشاء حساب
                        Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: color1.withOpacity(0.8),
                                offset: const Offset(0, 0),
                              ),
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),

                        // الخط المتحرك
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 80, end: isDesktop ? 200 : 140),
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeInOut,
                          builder: (context, width, child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                height: 4,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white.withOpacity(0.9),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 15.0,
                                      color: color2,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),

                        Text(
                          'انضم إلينا اليوم!',
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: spacing),

                        // نوع المستخدم
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نوع المستخدم',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: inputFontSize),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: _userType,
                              items: [
                                DropdownMenuItem(
                                  value: 'customer',
                                  child: Text('عميل', style: TextStyle(color: Colors.black, fontSize: inputFontSize)),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _userType = value!;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing / 2),

                        // رقم الهاتف
                        IntlPhoneField(
                          controller: _phoneController,
                          style: TextStyle(color: Colors.black, fontSize: inputFontSize),
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          initialCountryCode: 'SA',
                          onChanged: (phone) {
                            _fullPhoneNumber = phone.completeNumber;
                          },
                          validator: (value) {
                            if (value == null || value.number.isEmpty) return 'يرجى إدخال رقم الهاتف';
                            return null;
                          },
                        ),
                        SizedBox(height: spacing / 2),

                        // كلمة المرور
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: Colors.black, fontSize: inputFontSize),
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
                            if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            return null;
                          },
                        ),
                        SizedBox(height: spacing / 2),

                        // تأكيد كلمة المرور
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(color: Colors.black, fontSize: inputFontSize),
                          decoration: InputDecoration(
                            labelText: 'تأكيد كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
                            if (value != _passwordController.text) return 'كلمات المرور غير متطابقة';
                            return null;
                          },
                        ),
                        SizedBox(height: spacing / 2),

                        // رسالة الخطأ
                        if (authProvider.error.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              authProvider.error,
                              style: TextStyle(color: Colors.red, fontSize: inputFontSize),
                            ),
                          ),
                        if (authProvider.error.isNotEmpty) SizedBox(height: spacing / 2),

                        // زر التسجيل
                        SizedBox(
                          width: double.infinity,
                          height: isDesktop ? 60 : 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color1,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final success = await authProvider.register(
                                        _fullPhoneNumber,
                                        _passwordController.text,
                                        _userType,
                                      );
                                      if (success && context.mounted) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/verify-phone',
                                          arguments: _fullPhoneNumber,
                                        );
                                      }
                                    }
                                  },
                            child: authProvider.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'إنشاء حساب',
                                    style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        SizedBox(height: spacing),

                        // رابط تسجيل الدخول
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('لديك حساب بالفعل؟', style: TextStyle(color: Colors.black87, fontSize: inputFontSize)),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(color: color1, fontWeight: FontWeight.bold, fontSize: inputFontSize),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
