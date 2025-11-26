import 'package:customer/data/models/complete_profile_model.dart';
import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:customer/presentation/providers/complete_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CompleteProfileScreen extends StatefulWidget {
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Personal Info
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactPositionController = TextEditingController();

  // Document files
  final Map<String, PlatformFile?> _documentFiles = {
    'commercialLicense': null,
    'energyLicense': null,
    'commercialRecord': null,
    'taxNumber': null,
    'nationalAddressDocument': null,
    'civilDefenseLicense': null,
  };

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final completeProfileProvider = Provider.of<CompleteProfileProvider>(context, listen: false);
      if (completeProfileProvider.completeProfile != null) {
        _populateExistingData(completeProfileProvider.completeProfile!);
      }
    });
  }

  void _populateExistingData(CompleteProfileModel profile) {
    setState(() {
      _companyNameController.text = profile.companyName;
      _emailController.text = profile.email;
      _contactPersonController.text = profile.contactPerson;
      _contactPhoneController.text = profile.contactPhone;
      _contactPositionController.text = profile.contactPosition ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final completeProfileProvider = Provider.of<CompleteProfileProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        elevation: 0,
        title: Text(
          'إكمال الملف الشخصي',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF303F9F),
            ],
          ),
        ),
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressStep(0, 'المعلومات الشخصية'),
                  SizedBox(width: 10),
                  _buildProgressStep(1, 'المستندات'),
                ],
              ),
            ),
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      'رجوع',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (_currentStep > 0) SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7986CB),
                                  Color(0xFF5C6BC0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF5C6BC0).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentStep == 1 ? 'إرسال' : 'متابعة',
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (_currentStep < 1) ...[
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  _buildStep(
                    title: 'المعلومات الشخصية',
                    content: _buildPersonalInfoStep(),
                    stepIndex: 0,
                  ),
                  _buildStep(
                    title: 'رفع المستندات',
                    content: _buildDocumentsStep(),
                    stepIndex: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(int stepIndex, String title) {
    bool isActive = _currentStep >= stepIndex;
    bool isCompleted = _currentStep > stepIndex;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF7986CB) : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCompleted)
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 18)
              else
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFF7986CB) : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: isActive 
                      ? Icon(Icons.check_rounded, color: Colors.white, size: 14)
                      : null,
                ),
              SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.cairo(
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Step _buildStep({
    required String title,
    required Widget content,
    required int stepIndex,
  }) {
    return Step(
      title: Text(
        title,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: content,
      isActive: _currentStep >= stepIndex,
      state: _currentStep > stepIndex ? StepState.complete : StepState.indexed,
    );
  }

  void _onStepContinue() {
    if (_currentStep < 1) {
      final currentFormKey = _formKeys[_currentStep];
      if (currentFormKey.currentState == null) {
        setState(() {
          _currentStep += 1;
        });
        return;
      }

      if (currentFormKey.currentState!.validate()) {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      Future.microtask(() => _submitProfile(Provider.of<CompleteProfileProvider>(context, listen: false)));
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildPersonalInfoStep() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Form(
        key: _formKeys[0],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildGlassTextField(
                controller: _companyNameController,
                label: 'اسم الشركة *',
                icon: Icons.business_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الشركة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildGlassTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني *',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildGlassTextField(
                controller: _contactPersonController,
                label: 'اسم الشخص المسؤول *',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الشخص المسؤول';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildGlassTextField(
                controller: _contactPhoneController,
                label: 'هاتف الشخص المسؤول *',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال هاتف الشخص المسؤول';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildGlassTextField(
                controller: _contactPositionController,
                label: 'المنصب',
                icon: Icons.work_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.cairo(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 12, left: 8),
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white70, size: 22),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDocumentsStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.blue, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'معلومات مهمة',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'يرجى رفع المستندات المطلوبة بصيغة PDF أو صورة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'جميع المستندات إلزامية',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildDocumentItem(
            'الرخصة التجارية',
            'commercialLicense',
            icon: Icons.business_center_rounded,
            color: Color(0xFF4CAF50),
          ),
          _buildDocumentItem(
            'رخصة الطاقة',
            'energyLicense',
            icon: Icons.bolt_rounded,
            color: Color(0xFFFF9800),
          ),
          _buildDocumentItem(
            'السجل التجاري',
            'commercialRecord',
            icon: Icons.assignment_rounded,
            color: Color(0xFF2196F3),
          ),
          _buildDocumentItem(
            'الرقم الضريبي',
            'taxNumber',
            icon: Icons.receipt_rounded,
            color: Color(0xFF9C27B0),
          ),
          _buildDocumentItem(
            'وثيقة العنوان الوطني',
            'nationalAddressDocument',
            icon: Icons.location_on_rounded,
            color: Color(0xFFF44336),
          ),
          _buildDocumentItem(
            'رخصة الدفاع المدني',
            'civilDefenseLicense',
            icon: Icons.security_rounded,
            color: Color(0xFF607D8B),
          ),
          SizedBox(height: 20),
          _buildDocumentsSummary(),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String documentName, String documentKey, {
    required IconData icon,
    required Color color,
  }) {
    final hasFile = _documentFiles[documentKey] != null;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    documentName,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (hasFile)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded, color: Colors.green, size: 18),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: hasFile 
                          ? LinearGradient(
                              colors: [Colors.green.shade600, Colors.green.shade800],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [color.withOpacity(0.8), color],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: hasFile 
                          ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickDocument(documentKey),
                      icon: Icon(
                        hasFile ? Icons.change_circle_rounded : Icons.cloud_upload_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      label: Text(
                        hasFile ? 'تغيير الملف' : 'رفع الملف',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (hasFile)
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade800,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => _viewDocument(documentKey),
                      icon: Icon(Icons.visibility_rounded, color: Colors.white, size: 22),
                      tooltip: 'معاينة الملف',
                    ),
                  ),
              ],
            ),
            
            if (hasFile)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تم رفع: ${_documentFiles[documentKey]?.name ?? ''}',
                          style: GoogleFonts.cairo(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSummary() {
    final uploadedCount = _documentFiles.values.where((file) => file != null).length;
    final totalCount = _documentFiles.length;
    final allUploaded = uploadedCount == totalCount;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: allUploaded
              ? [Colors.green.withOpacity(0.15), Colors.green.withOpacity(0.05)]
              : [Colors.orange.withOpacity(0.15), Colors.orange.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: allUploaded ? Colors.green.withOpacity(0.4) : Colors.orange.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: allUploaded ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              allUploaded ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
              color: allUploaded ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allUploaded ? 'جميع المستندات جاهزة' : 'مستوى الإكمال',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: allUploaded ? Colors.green : Colors.orange,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  allUploaded 
                    ? 'تم رفع جميع المستندات المطلوبة بنجاح'
                    : 'تم رفع $uploadedCount من أصل $totalCount مستند',
                  style: GoogleFonts.cairo(
                    color: allUploaded ? Colors.green : Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDocument(String documentKey) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'heic'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _documentFiles[documentKey] = result.files.first;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('تم رفع الملف بنجاح: ${result.files.first.name}'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('خطأ في رفع الملف: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _viewDocument(String documentKey) async {
    final file = _documentFiles[documentKey];
    if (file == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A237E).withOpacity(0.95),
                Color(0xFF283593).withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'معاينة الملف',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildFileInfoItem('اسم الملف', file.name),
                _buildFileInfoItem('الحجم', '${(file.size / 1024 / 1024).toStringAsFixed(2)} MB'),
                _buildFileInfoItem('النوع', file.extension?.toUpperCase() ?? "غير معروف"),
                SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7986CB),
                          Color(0xFF5C6BC0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF5C6BC0).withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'إغلاق',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfoItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitProfile(CompleteProfileProvider completeProfileProvider) async {
    await completeProfileProvider.debugTokenStatus();
    
    final isAuthenticated = await completeProfileProvider.isUserAuthenticated();
    
    if (!isAuthenticated) {
      if (context.mounted) {
        _showLoginRequiredDialog();
      }
      return;
    }

    print('✅ User is authenticated, proceeding with submission...');

    setState(() {
      _currentStep = 0;
    });

    // التحقق من رفع جميع المستندات الإلزامية
    for (var entry in _documentFiles.entries) {
      if (entry.value == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text('يرجى رفع جميع المستندات الإلزامية'),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        return;
      }
    }

    // تجميع البيانات الشخصية
    final personalInfo = {
      'companyName': _companyNameController.text,
      'email': _emailController.text,
      'contactPerson': _contactPersonController.text,
      'contactPhone': _contactPhoneController.text,
      'contactPosition': _contactPositionController.text,
    };

    // تجميع بيانات المستندات
    final documentsData = {
      'documents': {
        'commercialLicense': {
          'file': _documentFiles['commercialLicense']?.path ?? '',
        },
        'energyLicense': {
          'file': _documentFiles['energyLicense']?.path ?? '',
        },
        'commercialRecord': {
          'file': _documentFiles['commercialRecord']?.path ?? '',
        },
        'taxNumber': {
          'file': _documentFiles['taxNumber']?.path ?? '',
        },
        'nationalAddressDocument': {
          'file': _documentFiles['nationalAddressDocument']?.path ?? '',
        },
        'civilDefenseLicense': {
          'file': _documentFiles['civilDefenseLicense']?.path ?? '',
        },
      }
    };

    // حفظ البيانات في الـ provider أولاً
    completeProfileProvider.updateProfileData(personalInfo);
    completeProfileProvider.updateDocumentsData(documentsData);

    // إرسال البيانات للمراجعة
    final success = await completeProfileProvider.submitProfileForReview();

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('تم إرسال الملف الشخصي للمراجعة بنجاح'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Future.microtask(() => Navigator.pop(context));
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('خطأ في إرسال الملف: ${completeProfileProvider.error}'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A237E),
                Color(0xFF283593),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.login_rounded, color: Colors.white, size: 32),
                ),
                SizedBox(height: 16),
                Text(
                  'تسجيل الدخول مطلوب',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  textAlign: TextAlign.center,
                  'يجب تسجيل الدخول أولاً لإرسال الملف الشخصي للمراجعة.',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 14,
                    
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF5C6BC0).withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _contactPositionController.dispose();
    super.dispose();
  }
}