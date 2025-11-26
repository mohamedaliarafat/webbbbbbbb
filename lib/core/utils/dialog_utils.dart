import 'package:customer/core/constants/app_colors.dart';
import 'package:customer/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils._internal();
  factory DialogUtils() => _instance;
  DialogUtils._internal();

  final Logger _logger = Logger();

  // Show loading dialog
  void showLoadingDialog(BuildContext context, {String message = AppStrings.loading}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    _logger.i('⏳ Loading dialog shown: $message');
  }

  // Hide loading dialog
  void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      _logger.i('⏳ Loading dialog hidden');
    }
  }

  // Show success dialog
  Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = AppStrings.ok,
    VoidCallback? onPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
    _logger.i('✅ Success dialog shown: $title');
  }

  // Show error dialog
  Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = AppStrings.ok,
    VoidCallback? onPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
    _logger.e('❌ Error dialog shown: $title - $message');
  }

  // Show confirmation dialog
  Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppStrings.confirm,
    String cancelText = AppStrings.cancel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? AppColors.error : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    _logger.i('❓ Confirmation dialog shown: $title - Result: ${result ?? false}');
    return result ?? false;
  }

  // Show delete confirmation dialog
  Future<bool> showDeleteConfirmationDialog(
    BuildContext context, {
    String itemName = '',
  }) async {
    return await showConfirmationDialog(
      context,
      title: AppStrings.confirmDelete,
      message: itemName.isNotEmpty 
          ? 'هل أنت متأكد من حذف $itemName؟'
          : AppStrings.confirmDelete,
      confirmText: AppStrings.delete,
      isDestructive: true,
    );
  }

  // Show logout confirmation dialog
  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showConfirmationDialog(
      context,
      title: 'تأكيد تسجيل الخروج',
      message: AppStrings.confirmLogout,
      confirmText: AppStrings.logout,
    );
  }

  // Show info dialog
  Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = AppStrings.ok,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.info),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
    _logger.i('ℹ️ Info dialog shown: $title');
  }

  // Show warning dialog
  Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = AppStrings.ok,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
    _logger.w('⚠️ Warning dialog shown: $title');
  }

  // Show bottom sheet
  Future<T?> showCustomBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => child,
    );

    _logger.i('📄 Bottom sheet shown and closed with result: $result');
    return result;
  }

  // Show selection dialog
  Future<int?> showSelectionDialog(
    BuildContext context, {
    required String title,
    required List<String> options,
    int initialSelection = 0,
  }) async {
    int selectedIndex = initialSelection;

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return RadioListTile<int>(
                value: index,
                groupValue: selectedIndex,
                title: Text(options[index]),
                onChanged: (value) {
                  selectedIndex = value!;
                  Navigator.of(context).pop(selectedIndex);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
        ],
      ),
    );

    _logger.i('📋 Selection dialog shown: $title - Result: $result');
    return result;
  }

  // Show input dialog
  Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? hintText,
    String initialValue = '',
    String confirmText = AppStrings.save,
    String cancelText = AppStrings.cancel,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) async {
    final textController = TextEditingController(text: initialValue);
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: hintText,
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
              keyboardType: keyboardType,
              maxLines: maxLines,
              onChanged: (value) {
                if (validator != null) {
                  setState(() {
                    errorText = validator(value);
                  });
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(cancelText),
              ),
              TextButton(
                onPressed: errorText == null && textController.text.isNotEmpty
                    ? () => Navigator.of(context).pop(textController.text)
                    : null,
                child: Text(confirmText),
              ),
            ],
          );
        },
      ),
    );

    _logger.i('📝 Input dialog shown: $title - Result: ${result ?? 'cancelled'}');
    return result;
  }

  // Show image picker dialog
  Future<ImageSource?> showImagePickerDialog(BuildContext context) async {
    final result = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر مصدر الصورة'),
        content: const Text('من أين تريد اختيار الصورة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: const Text('الكاميرا'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: const Text('المعرض'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
        ],
      ),
    );

    _logger.i('🖼️ Image picker dialog shown - Result: $result');
    return result;
  }

  // Show date picker dialog
  Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final result = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.navyBlueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    _logger.i('📅 Date picker dialog shown - Result: $result');
    return result;
  }

  // Show time picker dialog
  Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) async {
    final result = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.navyBlueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    _logger.i('⏰ Time picker dialog shown - Result: $result');
    return result;
  }

  // Show custom dialog with custom widget
  Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );

    _logger.i('💬 Custom dialog shown - Result: $result');
    return result;
  }
}