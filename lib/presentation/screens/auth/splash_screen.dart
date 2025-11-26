import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _bottomLogosFadeAnimation;
  late Animation<double> _slideAnimation; // لتحريك الدوائر البيضاوية
  
  // لرسوم تحول الألوان
  late Animation<Color?> _colorAnimation; 
  int _currentColorIndex = 0;
  final List<Color> _colors = [
    Color(0xFF0A0E21), // أزرق داكن جداً (كحلي)
    Color(0xFF1A237E), // أزرق داكن
    Color(0xFF283593),
    Color(0xFF303F9F),
    Color(0xFF3949AB),
    Color(0xFF5C6BC0), // أزرق متوسط
    Color(0xFF7986CB),
    Color(0xFF9FA8DA),
    Color(0xFFC5CAE9),
    Color(0xFFE8EAF6), // فاتح جداً
    Color(0xFFC5CAE9), // بدء العودة
    Color(0xFF9FA8DA),
    Color(0xFF7986CB),
    Color(0xFF5C6BC0),
    Color(0xFF3949AB),
    Color(0xFF303F9F),
    Color(0xFF283593),
    Color(0xFF1A237E), // العودة إلى الداكن
  ];
  
  // متغير للتحكم في تأثير الانقسام
  bool _isSpliting = false;
  double _leftSplitWidth = 0;
  double _rightSplitWidth = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAuthCheck();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8), // تقليل المدة لتكون 8 ثواني لترك 7 ثواني لتأثير الانقسام
    );

    // الرسوم المتحركة الأساسية (نفس الكود الأصلي)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.3, curve: Curves.easeInOut),
    ));

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.5, curve: Curves.easeInOut),
    ));

    _bottomLogosFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 0.7, curve: Curves.easeInOut),
    ));
    
    // الرسوم المتحركة لتحريك الدوائر البيضاوية
    _slideAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear, // حركة مستمرة وثابتة
    ));

    // تهيئة تحول الألوان الأولي
    _colorAnimation = ColorTween(
      begin: _colors[0],
      end: _colors[1],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startSplitAnimation();
      }
    });

    _animationController.addListener(() {
      final progress = _animationController.value;
      
      // منطق تحول الألوان السلس
      final numColors = _colors.length - 1;
      final newColorIndex = (progress * numColors).floor().clamp(0, numColors - 1);
      
      if (newColorIndex != _currentColorIndex) {
        setState(() {
          _currentColorIndex = newColorIndex;
          final nextIndex = (_currentColorIndex + 1) % _colors.length;
          
          final startInterval = _currentColorIndex / numColors;
          final endInterval = nextIndex / numColors;

          _colorAnimation = ColorTween(
            begin: _colors[_currentColorIndex],
            end: _colors[nextIndex],
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(startInterval, endInterval, curve: Curves.easeInOut),
          ));
        });
      }
    });

    _animationController.forward();
  }

  void _startSplitAnimation() async {
    // تشغيل تأثير الانقسام
    setState(() {
      _isSpliting = true;
      _leftSplitWidth = MediaQuery.of(context).size.width / 2;
      _rightSplitWidth = MediaQuery.of(context).size.width / 2;
    });

    // الانتظار لانتهاء انيميشن الانقسام (مثلاً 1000 مللي ثانية)
    await Future.delayed(Duration(milliseconds: 1000));
    
    // استكمال التحقق من المصادقة والانتقال
    if (mounted) {
      // _checkAuthStatus تم تعديله ليستخدم Navigator.pushReplacementNamed مباشرة
      // بعد الانتظار الكافي (المجموع الكلي 15 ثانية - 8 ثواني للرسوم = 7 ثواني للانتظار)
    }
  }

  // تم إلغاء الحاجة لـ _createSplitRoute واستخدام _buildSplitScreen داخل الـ _checkAuthStatus
  // في الكود الأصلي، لكن بما أن المستخدم طلب التعديل على الـUI
  // سنبقي على الـ _checkAuthStatus كما هي ونعتمد على الحركة المرئية في build

  void _startAuthCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // نبدأ التحقق فوراً ولكن الانتقال يتم بعد التأخير الكلي
      // لضمان تزامن التحقق من المصادقة مع انتهاء الرسوم المتحركة.
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // إجمالي مدة الرسوم المتحركة التي نريدها هي 15 ثانية (8 ثواني رسوم + 1 ثانية انقسام + 6 ثواني انتظار)
    // الكود الأصلي ينتظر 15 ثانية بعد بدء الـ _initAnimations، سنقوم بتعديل هذا
    // الانتظار ليتوافق مع المدة الجديدة للـ animationController + انتظار الـ split
    
    // الانتظار لانتهاء الانيميشن (8 ثواني) + انتظار تأثير الانقسام (1 ثانية)
    await Future.delayed(Duration(milliseconds: 8000 + 1000)); 
    
    // انتظر حتى ينتهي التحقق من حالة المصادقة (إذا كان لا يزال جارياً)
    while (authProvider.isCheckingAuth) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    // انتظار مدة إضافية (6 ثواني) لضمان إجمالي 15 ثانية تقريباً (حسب الكود الأصلي)
    // بما أننا عدّلنا مدة الـ animationController إلى 8 ثوانٍ، سننتظر الفرق
    // Duration(seconds: 15) - Duration(seconds: 8) - Duration(milliseconds: 1000) = Duration(seconds: 6)
    await Future.delayed(Duration(seconds: 6));
    
    if (mounted) {
      final nextRoute = authProvider.isLoggedIn ? '/home' : '/login';
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إذا كان تأثير الانقسام قد بدأ، اعرض شاشة الانقسام بدلاً من شاشة الـSplashScreen العادية
    if (_isSpliting) {
      return _buildSplitScreen();
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final slideValue = _slideAnimation.value;
    
    // حساب قيمة لون التدرج اللوني الحالي
    final color1 = _colorAnimation.value ?? _colors[0];
    final color2 = _colors[(_currentColorIndex + 1) % _colors.length];
    final color3 = _colors[(_currentColorIndex + 2) % _colors.length];
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            // استخدام التدرج اللوني المتحول
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2, color3],
              ),
            ),
            child: Stack(
              children: [
                // 1. الدائرة البيضاوية العلوية المتحركة
                Positioned(
                  top: -screenHeight * 0.3 + (slideValue * screenHeight * 0.1), // حركة للأعلى والأسفل
                  left: -screenWidth * 0.5 + (slideValue * screenWidth * 0.3), // حركة من الجوانب
                  child: Opacity(
                    opacity: 0.3, // شفافة قليلاً
                    child: Container(
                      width: screenWidth * 1.5,
                      height: screenWidth * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. الدائرة البيضاوية السفلية المتحركة
                Positioned(
                  bottom: -screenHeight * 0.3 - (slideValue * screenHeight * 0.1), // حركة للأسفل والأعلى
                  right: -screenWidth * 0.5 - (slideValue * screenWidth * 0.3), // حركة من الجوانب المعاكسة
                  child: Opacity(
                    opacity: 0.3, // شفافة قليلاً
                    child: Container(
                      width: screenWidth * 1.5,
                      height: screenWidth * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // المحتوى الرئيسي
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الصورة الرئيسية
                      Opacity(
                        opacity: _logoFadeAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // النص الرئيسي
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            Text(
                              'البحيرة العربية للنقليات',
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'وقودك يوصلك أسهل',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Cairo",
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 50),
                      
                      // الصور السفلية
                      Opacity(
                        opacity: _bottomLogosFadeAnimation.value,
                        child: Container(
                          height: 210,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                height: 100,
                                child: Image.asset(
                                  'assets/images/energylogo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              
                              Container(
                                width: 250,
                                height: 100,
                                child: Image.asset(
                                  'assets/images/aramcologo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // شاشة الانقسام بعد انتهاء مدة الرسوم المتحركة
  Widget _buildSplitScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // النصف الأيسر (تم ربط الـ width بمتغير _leftSplitWidth ليتم التعديل عليه عند الحاجة مستقبلاً)
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000), // مدة انيميشن الانقسام
            left: 0,
            top: 0,
            bottom: 0,
            width: _leftSplitWidth, 
            child: Container(
              color: Color(0xFF1A237E), // أزرق داكن (كحلي)
              child: Center(
                child: Icon(
                  Icons.local_gas_station,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // النصف الأيمن (تم ربط الـ width بمتغير _rightSplitWidth ليتم التعديل عليه عند الحاجة مستقبلاً)
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000), // مدة انيميشن الانقسام
            right: 0,
            top: 0,
            bottom: 0,
            width: _rightSplitWidth,
            child: Container(
              color: Color(0xFF303F9F), // أزرق متوسط
              child: Center(
                child: Text(
                  'البحيرة العربية',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Cairo",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}