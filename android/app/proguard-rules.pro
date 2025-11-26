########################################
# ✅ قواعد ProGuard الأساسية لتطبيقات Flutter
########################################

# احتفظ بجميع الكلاسات المرتبطة بـ Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# تجاهل التحذيرات الخاصة بـ Flutter
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugins.**

########################################
# ✅ قواعد Firebase
########################################

-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

########################################
# ✅ قواعد Gson (في حال تستخدم JSON parsing)
########################################

-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.examples.android.model.** { *; }
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

########################################
# ✅ قواعد Glide (الصور)
########################################

-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.AppGlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** { **[] $VALUES; public *; }
-dontwarn com.bumptech.glide.**

########################################
# ✅ قواعد Stripe (حل مشكلة Missing class)
########################################

# Stripe SDK
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**

# React Native Stripe SDK
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

########################################
# ✅ قواعد Retrofit / OkHttp (في حال تستخدم API)
########################################

-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**

########################################
# ✅ قواعد عامة لحماية الكود مع ضمان عمله
########################################

# لا تزيل الكلاسات التي يُحتمل استدعاؤها ديناميكيًا
-keep class androidx.** { *; }
-dontwarn androidx.**

# احتفظ بجميع الأصناف التي تحتوي على "Model" أو "Response"
-keep class **Model { *; }
-keep class **Response { *; }

# تجاهل التحذيرات العامة
-dontwarn javax.annotation.**
-dontwarn org.jetbrains.annotations.**
-dontwarn kotlin.**

########################################
# ✅ نهاية الملف
########################################
