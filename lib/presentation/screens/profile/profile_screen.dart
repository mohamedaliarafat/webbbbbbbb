import 'dart:ui';
import 'package:customer/data/models/user_model.dart';
import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:customer/presentation/providers/complete_profile_provider.dart';
import 'package:customer/presentation/providers/user_provider.dart';
import 'package:customer/presentation/screens/auth/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';
import 'addresses_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _initialLoad = false;
  bool _isLoading = true;
  bool _hasProfileError = false;

  // دوال الاستجابة للأحجام
  double get _responsiveWidth {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? width * 0.8 : width;
  }

  double get _responsivePadding {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 24.0 : 16.0;
  }

  double get _responsiveSmallPadding {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 16.0 : 12.0;
  }

  double get _responsiveIconSize {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 28.0 : 24.0;
  }

  double get _responsiveLargeIconSize {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 40.0 : 32.0;
  }

  double get _responsiveFontSize {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return 18.0;
    } else if (width > 400) {
      return 16.0;
    } else {
      return 14.0;
    }
  }

  double get _responsiveTitleFontSize {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 24.0 : 20.0;
  }

  double get _responsiveSubtitleFontSize {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 20.0 : 18.0;
  }

  double get _responsiveAppBarHeight {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 250.0 : 200.0;
  }

  double get _responsiveAvatarSize {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 100.0 : 80.0;
  }

  double get _responsiveCardPadding {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 28.0 : 20.0;
  }

  double get _responsiveButtonHeight {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 56.0 : 48.0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() async {
    if (_initialLoad) return;
    
    final authProvider = context.read<AuthProvider>();
    final completeProfileProvider = context.read<CompleteProfileProvider>();
    
    if (authProvider.user != null) {
      print('👤 User found, loading profile data...');
      
      try {
        await context.read<UserProvider>().loadUser(authProvider.user!.id);
        
        try {
          await completeProfileProvider.loadCompleteProfile();
          _hasProfileError = false;
          print('✅ Profile loading completed');
        } catch (e) {
          _hasProfileError = true;
          print('⚠️ Profile not found or error: $e');
        }
        
        _initialLoad = true;
        
      } catch (e) {
        print('❌ Error loading user data: $e');
        _hasProfileError = true;
      }
    } else {
      print('❌ No user found in auth provider');
      _hasProfileError = true;
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final completeProfileProvider = context.watch<CompleteProfileProvider>();
    
    final UserModel? user = authProvider.user ?? userProvider.currentUser;

    final bool isProfileComplete = _checkProfileCompletion(
      completeProfileProvider, 
      _hasProfileError
    );

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: _responsiveWidth,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: _responsiveAppBarHeight,
                leading: Container(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black,
                          Color(0xFF1a1a1a),
                          Colors.black,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildGlassUserHeader(user, isProfileComplete),
                        SizedBox(height: _responsivePadding * 1.25),
                      ],
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: _responsivePadding),
                  if (!isProfileComplete || _hasProfileError)
                    _buildGlassProfileCompletionCard(),
                  if (isProfileComplete && !_hasProfileError)
                    _buildCompletedProfileCard(user),
                  _buildGlassMenuItems(user, isProfileComplete),
                  SizedBox(height: _responsivePadding * 1.5),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkProfileCompletion(CompleteProfileProvider provider, bool hasError) {
    if (hasError) return false;
    if (!provider.hasCompleteProfile) return false;
    if (!provider.isProfileComplete) return false;
    return true;
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _responsiveAvatarSize,
              height: _responsiveAvatarSize,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: _responsivePadding),
            Text(
              'جاري تحميل البيانات...',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: _responsiveFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassUserHeader(UserModel? user, bool isProfileComplete) {
    return Container(
      margin: EdgeInsets.all(_responsivePadding),
      padding: EdgeInsets.all(_responsiveCardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: _responsiveAvatarSize,
                height: _responsiveAvatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.3),
                      Colors.green.withOpacity(0.3),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: _responsiveAvatarSize / 2,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    user?.profileImage ?? 'https://via.placeholder.com/150',
                  ),
                ),
              ),
              if (isProfileComplete && !_hasProfileError)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: _responsiveIconSize * 0.8,
                    height: _responsiveIconSize * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: _responsiveIconSize * 0.5,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: _responsivePadding),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user?.name?.isNotEmpty == true ? user!.name! : 'مستخدم',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: _responsiveTitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: _responsiveSmallPadding),
                    if (isProfileComplete && !_hasProfileError)
                      Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: _responsiveIconSize,
                      ),
                  ],
                ),
                SizedBox(height: _responsiveSmallPadding / 2),
                Text(
                  user?.phone ?? '',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: _responsiveFontSize,
                  ),
                ),
                SizedBox(height: _responsiveSmallPadding),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _responsiveSmallPadding, 
                    vertical: _responsiveSmallPadding / 2
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getUserTypeText(user?.userType ?? 'customer'),
                        style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: _responsiveFontSize - 2,
                        ),
                      ),
                      if (isProfileComplete && !_hasProfileError) ...[
                        SizedBox(width: _responsiveSmallPadding / 2),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: _responsiveIconSize * 0.7,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: Icon(
                Icons.edit, 
                color: Colors.white,
                size: _responsiveIconSize,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedProfileCard(UserModel? user) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _responsivePadding, 
        vertical: _responsiveSmallPadding
      ),
      padding: EdgeInsets.all(_responsiveCardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_responsiveSmallPadding),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.verified_user, 
                  color: Colors.green, 
                  size: _responsiveIconSize
                ),
              ),
              SizedBox(width: _responsiveSmallPadding),
              Expanded(
                child: Text(
                  'الملف الشخصي مكتمل ومعتمد',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: _responsiveFontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _responsiveSmallPadding),
          Row(
            children: [
              Icon(
                Icons.check_circle, 
                color: Colors.green, 
                size: _responsiveIconSize * 0.8
              ),
              SizedBox(width: _responsiveSmallPadding),
              Expanded(
                child: Text(
                  'تمت الموافقة على جميع المستندات',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: _responsiveFontSize - 2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _responsiveSmallPadding / 2),
          Row(
            children: [
              Icon(
                Icons.check_circle, 
                color: Colors.green, 
                size: _responsiveIconSize * 0.8
              ),
              SizedBox(width: _responsiveSmallPadding),
              Expanded(
                child: Text(
                  'يمكنك الآن استخدام كافة الخدمات',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: _responsiveFontSize - 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassProfileCompletionCard() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _responsivePadding, 
        vertical: _responsiveSmallPadding
      ),
      padding: EdgeInsets.all(_responsiveCardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_responsiveSmallPadding),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.info_outline, 
                  color: Colors.orange, 
                  size: _responsiveIconSize
                ),
              ),
              SizedBox(width: _responsiveSmallPadding),
              Text(
                'إكمال الملف الشخصي',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: _responsiveFontSize,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: _responsiveSmallPadding),
          Text(
            _hasProfileError 
              ? 'لم يتم العثور على ملفك الشخصي. يرجى إكمال البيانات المطلوبة.'
              : 'يجب إكمال ملفك الشخصي لتفعيل كافة الخدمات',
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: _responsiveFontSize - 2,
            ),
          ),
          SizedBox(height: _responsivePadding),
          _buildGlassButton(
            text: 'إكمال الملف الشخصي',
            icon: Icons.assignment,
            color: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompleteProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlassMenuItems(UserModel? user, bool isProfileComplete) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _responsivePadding),
      padding: EdgeInsets.all(_responsiveCardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildGlassMenuItem(
            icon: Icons.person_outline,
            title: 'المعلومات الشخصية',
            subtitle: 'تعديل بياناتك الشخصية',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
          ),

          _buildGlassMenuItem(
            icon: Icons.location_on_outlined,
            title: 'العناوين',
            subtitle: 'إدارة عناوين التوصيل',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressesScreen(),
                ),
              );
            },
          ),

          if (!isProfileComplete || _hasProfileError)
            _buildGlassMenuItem(
              icon: Icons.assignment_outlined,
              title: 'إكمال الملف الشخصي',
              subtitle: 'إضافة المعلومات المطلوبة',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteProfileScreen(),
                  ),
                );
              },
            ),

          _buildGlassMenuItem(
            icon: Icons.history,
            title: 'سجل المدفوعات',
            subtitle: 'عرض جميع مدفوعاتك',
            color: Colors.purple,
            onTap: () {
              Navigator.pushNamed(context, "/hestoryPayments");
            },
          ),

          _buildGlassMenuItem(
            icon: Icons.help_outline,
            title: 'المساعدة والدعم',
            subtitle: 'مركز المساعدة',
            color: Colors.teal,
            onTap: () {
              Navigator.pushNamed(context, "/supports");
            },
          ),

          _buildGlassMenuItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            subtitle: 'خروج من التطبيق',
            color: Colors.red,
            isLogout: true,
            onTap: _showGlassLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: EdgeInsets.only(bottom: _responsiveSmallPadding),
          padding: EdgeInsets.all(_responsivePadding),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: _responsiveButtonHeight,
                height: _responsiveButtonHeight,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: _responsiveIconSize,
                ),
              ),
              SizedBox(width: _responsivePadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: _responsiveFontSize,
                      ),
                    ),
                    SizedBox(height: _responsiveSmallPadding / 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        color: Colors.white70,
                        fontSize: _responsiveFontSize - 2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: _responsiveIconSize * 0.8,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: _responsiveButtonHeight,
          padding: EdgeInsets.symmetric(
            horizontal: _responsivePadding, 
            vertical: _responsiveSmallPadding
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                color: color, 
                size: _responsiveIconSize
              ),
              SizedBox(width: _responsiveSmallPadding),
              Text(
                text,
                style: GoogleFonts.cairo(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: _responsiveFontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGlassLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: EdgeInsets.all(_responsiveCardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(_responsivePadding),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.logout, 
                    color: Colors.red, 
                    size: _responsiveLargeIconSize
                  ),
                ),
                SizedBox(height: _responsivePadding),
                Text(
                  'تسجيل الخروج',
                  style: GoogleFonts.cairo(
                    fontSize: _responsiveSubtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: _responsiveSmallPadding),
                Text(
                  'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: _responsiveFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _responsivePadding * 1.5),
                Row(
                  children: [
                    Expanded(
                      child: _buildGlassDialogButton(
                        text: 'إلغاء',
                        color: Colors.grey,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: _responsiveSmallPadding),
                    Expanded(
                      child: _buildGlassDialogButton(
                        text: 'تسجيل الخروج',
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                          _logout();
                        },
                        isPrimary: true,
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

  Widget _buildGlassDialogButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: _responsiveButtonHeight,
          padding: EdgeInsets.symmetric(vertical: _responsiveSmallPadding),
          decoration: BoxDecoration(
            color: isPrimary ? color.withOpacity(0.2) : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: _responsiveFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    try {
      await authProvider.logout();
      userProvider.clearUsers();
      
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/login', 
        (route) => false
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ في تسجيل الخروج: $e',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  String _getUserTypeText(String userType) {
    switch (userType) {
      case 'customer':
        return 'عميل';
      case 'driver':
        return 'سائق';
      case 'admin':
        return 'مدير';
      case 'approval_supervisor':
        return 'مشرف موافقات';
      case 'monitoring':
        return 'مراقب';
      default:
        return 'مستخدم';
    }
  }
}