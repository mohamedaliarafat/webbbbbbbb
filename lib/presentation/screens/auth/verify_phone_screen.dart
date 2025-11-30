import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phone;

  VerifyPhoneScreen({required this.phone});

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String _verificationCode = '';

  late AnimationController _animationController;

  final List<Color> _colorList1 = [const Color(0xFF4B77BE), const Color(0xFF67B26F)];
  final List<Color> _colorList2 = [const Color(0xFF67B26F), const Color(0xFF4B77BE)];

  @override
  void initState() {
    super.initState();
    _setupFocusNodes();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat(reverse: true);
  }

  void _setupFocusNodes() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          if (i > 0) {
            _focusNodes[i - 1].requestFocus();
          }
        }
      });
    }
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _updateVerificationCode();
  }

  void _updateVerificationCode() {
    setState(() {
      _verificationCode = _controllers.map((controller) => controller.text).join();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    // أحجام ديناميكية
    final iconSize = isDesktop ? 120.0 : 80.0;
    final titleFontSize = isDesktop ? 32.0 : 24.0;
    final subtitleFontSize = isDesktop ? 20.0 : 16.0;
    final codeFontSize = isDesktop ? 28.0 : 20.0;
    final buttonFontSize = isDesktop ? 22.0 : 18.0;
    final spacing = isDesktop ? 30.0 : 20.0;
    final codeBoxWidth = isDesktop ? 60.0 : 50.0;
    final codeBoxHeight = isDesktop ? 70.0 : 50.0;

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
                  child: Column(
                    children: [
                      SizedBox(height: spacing),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward, color: color1, size: iconSize * 0.3),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: spacing / 2),
                      Icon(
                        Icons.verified_user,
                        size: iconSize,
                        color: color1,
                      ),
                      SizedBox(height: spacing / 2),
                      Text(
                        'التحقق من رقم الهاتف',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: color2.withOpacity(0.8),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'أدخل الرمز المكون من 6 أرقام المرسل إلى',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.phone,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      // Verification Code Input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: codeBoxWidth,
                            height: codeBoxHeight,
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: codeFontSize,
                                fontWeight: FontWeight.bold,
                                color: color1,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: color2, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: color1, width: 3),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onChanged: (value) => _onCodeChanged(index, value),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: spacing / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('لم تستلم الرمز؟', style: TextStyle(color: Colors.white70, fontSize: subtitleFontSize)),
                          TextButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                    authProvider.clearError();
                                    await authProvider.resendVerification(widget.phone);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تم إرسال الرمز بنجاح'), backgroundColor: color2),
                                      );
                                    }
                                  },
                            child: Text(
                              'إعادة الإرسال',
                              style: TextStyle(color: color1, fontWeight: FontWeight.bold, fontSize: subtitleFontSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing / 2),
                      if (authProvider.error.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(spacing / 4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Text(
                            authProvider.error,
                            style: TextStyle(color: Colors.red, fontSize: subtitleFontSize),
                          ),
                        ),
                      if (authProvider.error.isNotEmpty) SizedBox(height: spacing / 2),
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
                          onPressed: authProvider.isLoading || _verificationCode.length != 6
                              ? null
                              : () async {
                                  final success = await authProvider.verifyPhone(
                                    widget.phone,
                                    _verificationCode,
                                  );
                                  if (success && context.mounted) {
                                    if (authProvider.user?.userType == 'driver') {
                                      Navigator.pushReplacementNamed(context, '/complete-profile');
                                    } else {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                  }
                                },
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'تحقق',
                                  style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      SizedBox(height: spacing),
                    ],
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
    for (var controller in _controllers) controller.dispose();
    for (var focusNode in _focusNodes) focusNode.dispose();
    super.dispose();
  }
}
