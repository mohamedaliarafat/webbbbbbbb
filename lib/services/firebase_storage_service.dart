// services/firebase_storage_service.dart
import 'dart:io';

import 'package:customer/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  static FirebaseStorage? _storage;
  static bool _isInitializing = false;

  // ✅ تهيئة Firebase Storage بشكل آمن
  static Future<void> _ensureInitialized() async {
    if (_storage != null) return;
    
    if (_isInitializing) {
      // انتظر حتى تنتهي التهيئة الجارية
      while (_isInitializing) {
        await Future.delayed(Duration(milliseconds: 50));
      }
      return;
    }

    _isInitializing = true;
    
    try {
      print('🔄 Initializing Firebase Storage...');
      
      // التحقق من وجود تطبيقات Firebase
      if (Firebase.apps.isEmpty) {
        print('❌ No Firebase apps found, trying to initialize...');
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      _storage = FirebaseStorage.instance;
      
      // اختبار بسيط للتأكد من أن الـ Storage يعمل
      try {
        await _storage!.ref('test_init').listAll().catchError((_) {});
      } catch (e) {
        print('⚠️ Storage test failed but continuing: $e');
      }
      
      print('✅ Firebase Storage initialized successfully');
      _isInitializing = false;
    } catch (e) {
      _isInitializing = false;
      print('❌ Firebase Storage initialization failed: $e');
      throw Exception('Failed to initialize Firebase Storage: $e');
    }
  }

  // ✅ الحصول على instance آمن
  static FirebaseStorage get _safeStorage {
    if (_storage == null) {
      throw Exception('Firebase Storage not initialized. Call _ensureInitialized() first.');
    }
    return _storage!;
  }

  // رفع ملف إلى Firebase Storage
  static Future<String> uploadFileToFirebase(File file, {String? customPath}) async {
    await _ensureInitialized(); // ✅ التأكد من التهيئة أولاً
    
    try {
      print('📤 Starting Firebase upload for: ${file.path}');
      String fileName = basename(file.path);
      String path = customPath ?? 'documents/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      Reference ref = _safeStorage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ File uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Firebase upload error: $e');
      throw Exception('فشل في رفع الملف إلى Firebase: $e');
    }
  }

  // رفع ملفات متعددة
  static Future<Map<String, String>> uploadMultipleFiles(Map<String, File> files) async {
    await _ensureInitialized(); // ✅ التأكد من التهيئة أولاً
    
    try {
      Map<String, String> uploadedUrls = {};
      
      for (var entry in files.entries) {
        String fileUrl = await uploadFileToFirebase(
          entry.value, 
          customPath: 'documents/${entry.key}_${DateTime.now().millisecondsSinceEpoch}'
        );
        uploadedUrls[entry.key] = fileUrl;
      }
      
      return uploadedUrls;
    } catch (e) {
      throw Exception('فشل في رفع الملفات المتعددة إلى Firebase: $e');
    }
  }

  // حذف ملف من Firebase Storage
  static Future<void> deleteFileFromFirebase(String fileUrl) async {
    await _ensureInitialized(); // ✅ التأكد من التهيئة أولاً
    
    try {
      Reference ref = _safeStorage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('فشل في حذف الملف من Firebase: $e');
    }
  }
}