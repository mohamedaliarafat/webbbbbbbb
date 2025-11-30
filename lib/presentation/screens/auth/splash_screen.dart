import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _startAuthCheck();
  }

  // تهيئة مشغل الفيديو
  void _initVideo() {
    // ⚠️ المسار الافتراضي: 'assets/videos/logo.mp4'
    _videoController = VideoPlayerController.asset('assets/videos/logo.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
        _videoController.play();
        _videoController.setLooping(true); // تشغيل الفيديو بشكل متكرر
      }).catchError((error) {
        print("خطأ في تهيئة الفيديو: $error");
        // في حال فشل تحميل الفيديو، يمكن عرض لون الخلفية الاحتياطي
      });
  }

  void _startAuthCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // الانتظار لمدة 15 ثانية (المدة المطلوبة)
    await Future.delayed(Duration(seconds: 15)); 
    
    // انتظار حتى ينتهي التحقق من حالة المصادقة (إذا كان لا يزال جارياً)
    while (authProvider.isCheckingAuth) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    if (mounted) {
      final nextRoute = authProvider.isLoggedIn ? '/home' : '/login';
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // عرض مؤشر التحميل (CircularProgressIndicator) إذا لم يتم تهيئة الفيديو بعد
    if (!_videoController.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    // عرض الفيديو فقط عندما يكون جاهزًا
    return Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover, // لتغطية الشاشة بالكامل
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      ),
    );
  }
}