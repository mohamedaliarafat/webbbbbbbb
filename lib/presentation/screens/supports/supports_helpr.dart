// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HelpSupportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0A0E21),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1A237E),
//         title: Padding(
//           padding: const EdgeInsets.only(right: 55),
//           child: Text(
//             'المساعدة والدعم',
//             style: GoogleFonts.cairo(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF1A237E),
//               Color(0xFF283593),
//               Color(0xFF303F9F),
//               Color(0xFF3949AB),
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               _buildHeaderSection(),
//               SizedBox(height: 32),

//               // Quick Actions
//               _buildQuickActionsSection(),
//               SizedBox(height: 32),

//               // FAQ Section
//               _buildFAQSection(),
//               SizedBox(height: 32),

//               // Contact Section
//               _buildContactSection(),
//               SizedBox(height: 32),

//               // Support Hours
//               _buildSupportHoursSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Container(
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: Icon(
//                   Icons.support_agent,
//                   size: 40,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'مرحباً بك في مركز المساعدة',
//                 style: GoogleFonts.cairo(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'نحن هنا لمساعدتك في أي استفسار أو مشكلة تواجهك',
//                 style: GoogleFonts.cairo(
//                   fontSize: 14,
//                   color: Colors.white70,
           
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Text(
//             'الإجراءات السريعة',
//             style: GoogleFonts.cairo(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(height: 16),
//         GridView.count(
//           crossAxisCount: 2,
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           childAspectRatio: 1.2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           children: [
//             _buildQuickActionCard(
//               icon: Icons.chat_bubble_outline,
//               title: 'الدردشة المباشرة',
//               subtitle: 'تواصل مع الدعم فوراً',
//               color: Color(0xFF64B5F6),
//               onTap: () {
//                 // Navigate to chat
//               },
//             ),
//             _buildQuickActionCard(
//               icon: Icons.phone_in_talk,
//               title: 'الاتصال الهاتفي',
//               subtitle: 'اتصل بفريق الدعم',
//               color: Color(0xFF81C784),
//               onTap: () {
//                 // Make phone call
//               },
//             ),
//             _buildQuickActionCard(
//               icon: Icons.email_outlined,
//               title: 'البريد الإلكتروني',
//               subtitle: 'أرسل رسالة بريد إلكتروني',
//               color: Color(0xFFFFB74D),
//               onTap: () {
//                 // Send email
//               },
//             ),
//             _buildQuickActionCard(
//               icon: Icons.help_outline,
//               title: 'الأسئلة الشائعة',
//               subtitle: 'استفسارات متكررة',
//               color: Color(0xFFBA68C8),
//               onTap: () {
//                 // Navigate to FAQ
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 color.withOpacity(0.3),
//                 color.withOpacity(0.1),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: color.withOpacity(0.3)),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.2),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: color.withOpacity(0.3)),
//                   ),
//                   child: Icon(icon, color: color, size: 22),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   title,
//                   style: GoogleFonts.cairo(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: GoogleFonts.cairo(
//                     color: Colors.white70,
//                     fontSize: 11,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFAQSection() {
//     final List<Map<String, String>> faqItems = [
//       {
//         'question': 'كيف يمكنني طلب وقود؟',
//         'answer': 'يمكنك طلب الوقود من خلال التبويب الثاني "طلب وقود" واتباع الخطوات'
//       },
//       {
//         'question': 'ما هي طرق الدفع المتاحة؟',
//         'answer': 'نحن نقبل التحويل البنكي '
//       },
//       {
//         'question': 'كم تستغرق وقت التوصيل؟',
//         'answer': 'يتم التوصيل خلال يوم - يومان عمل حسب الموقع والازدحام'
//       },
//       {
//         'question': 'كيف أتتبع طلبي؟',
//         'answer': 'يمكنك تتبع طلبك من خلال الوجهه الرئيسيه ثم اختيار "تتبع الطلب"'
//       },
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Text(
//             'الأسئلة الشائعة',
//             style: GoogleFonts.cairo(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(height: 16),
//         ...faqItems.map((faq) => _buildFAQItem(
//           question: faq['question']!,
//           answer: faq['answer']!,
//         )),
//       ],
//     );
//   }

//   Widget _buildFAQItem({required String question, required String answer}) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.white.withOpacity(0.1),
//             Colors.white.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: ExpansionTile(
//           tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           title: Text(
//             question,
//             style: GoogleFonts.cairo(
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           children: [
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 answer,
//                 style: GoogleFonts.cairo(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ],
//           iconColor: Colors.white,
//           collapsedIconColor: Colors.white70,
//         ),
//       ),
//     );
//   }

//   Widget _buildContactSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: Icon(Icons.contact_phone, color: Colors.white, size: 20),
//               ),
//               SizedBox(width: 12),
//               Text(
//                 'معلومات الاتصال',
//                 style: GoogleFonts.cairo(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           _buildContactInfoItem(
//             icon: Icons.phone,
//             title: 'الهاتف',
//             value: '+96654708118',
//             color: Color(0xFF81C784),
//           ),
//           _buildContactInfoItem(
//             icon: Icons.email,
//             title: 'البريد الإلكتروني',
//             value: 'albuhairaalarabia@gmail.com',
//             color: Color(0xFFFFB74D),
//           ),
//           _buildContactInfoItem(
//             icon: Icons.access_time,
//             title: 'ساعات العمل',
//             value: '24/7',
//             color: Color(0xFF64B5F6),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContactInfoItem({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               shape: BoxShape.circle,
//               border: Border.all(color: color.withOpacity(0.3)),
//             ),
//             child: Icon(icon, color: color, size: 18),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.cairo(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: GoogleFonts.cairo(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSupportHoursSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1A237E).withOpacity(0.7),
//             Color(0xFF283593).withOpacity(0.5),
//             Color(0xFF303F9F).withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: Icon(Icons.schedule, color: Colors.white, size: 20),
//               ),
//               SizedBox(width: 12),
//               Text(
//                 'ساعات الدعم',
//                 style: GoogleFonts.cairo(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           _buildSupportHourItem('السبت - الخميس', '8:00 ص - 12:00 م'),
//           _buildSupportHourItem('الجمعة', '4:00 م - 12:00 م'),
//           _buildSupportHourItem('الدعم الطارئ', '24/7'),
//         ],
//       ),
//     );
//   }

//   Widget _buildSupportHourItem(String day, String time) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             day,
//             style: GoogleFonts.cairo(
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             time,
//             style: GoogleFonts.cairo(
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Text(
            'المساعدة والدعم',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
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
              Color(0xFF3949AB),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              SizedBox(height: 32),

              // Quick Actions
              _buildQuickActionsSection(context),
              SizedBox(height: 32),

              // FAQ Section
              _buildFAQSection(),
              SizedBox(height: 32),

              // Contact Section
              _buildContactSection(),
              SizedBox(height: 32),

              // Support Hours
              _buildSupportHoursSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E).withOpacity(0.7),
            Color(0xFF283593).withOpacity(0.5),
            Color(0xFF303F9F).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(
                  Icons.support_agent,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'مرحباً بك في مركز المساعدة',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'نحن هنا لمساعدتك في أي استفسار أو مشكلة تواجهك',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'الإجراءات السريعة',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildQuickActionCard(
              icon: Icons.chat_bubble_outline,
              title: 'الدردشة المباشرة',
              subtitle: 'تواصل مع الدعم فوراً',
              color: Color(0xFF64B5F6),
              onTap: () {
                // Navigate to chat
              },
            ),
            _buildQuickActionCard(
              icon: Icons.phone_in_talk,
              title: 'الاتصال الهاتفي',
              subtitle: 'اتصل بفريق الدعم',
              color: Color(0xFF81C784),
              onTap: () {
                _showContactNumbers(context);
              },
            ),
            _buildQuickActionCard(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              subtitle: 'أرسل رسالة بريد إلكتروني',
              color: Color(0xFFFFB74D),
              onTap: () {
                _sendEmail(context);
              },
            ),
            _buildQuickActionCard(
              icon: Icons.help_outline,
              title: 'الأسئلة الشائعة',
              subtitle: 'استفسارات متكررة',
              color: Color(0xFFBA68C8),
              onTap: () {
                // Navigate to FAQ
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactNumbers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Color(0xFF1A237E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF283593),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.phone_in_talk, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'اتصل بفريق الدعم',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // رقم الدعم الفني
                      _buildContactItem(
                        context,
                        title: 'الدعم الفني',
                        number: '+96654708118',
                        icon: Icons.support_agent,
                        color: Colors.blue,
                      ),
                      
                      SizedBox(height: 12),
                      
                      // رقم خدمة العملاء
                      _buildContactItem(
                        context,
                        title: 'خدمة العملاء',
                        number: '+966500000002',
                        icon: Icons.headset_mic,
                        color: Colors.green,
                      ),
                      
                      SizedBox(height: 12),
                      
                      // رقم الطوارئ
                      _buildContactItem(
                        context,
                        title: 'الطوارئ',
                        number: '+966500000003',
                        icon: Icons.emergency,
                        color: Colors.red,
                      ),
                      
                      SizedBox(height: 12),
                      
                      // رقم المبيعات
                      _buildContactItem(
                        context,
                        title: 'قسم المبيعات',
                        number: '+966500000004',
                        icon: Icons.shopping_cart,
                        color: Colors.orange,
                      ),

                      SizedBox(height: 20),
                      
                      // معلومات إضافية
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.yellow, size: 10),
                                SizedBox(width: 8),
                                Text(
                                  'معلومات هامة',
                                  style: GoogleFonts.cairo(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'جميع المكالمات من داخل المملكة العربية السعودية',
                              style: GoogleFonts.cairo(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Close Button
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'إغلاق',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactItem(BuildContext context, {
    required String title,
    required String number,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          number,
          style: GoogleFonts.cairo(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زر الاتصال المباشر
            IconButton(
              onPressed: () async {
                final Uri telLaunchUri = Uri(
                  scheme: 'tel',
                  path: number,
                );
                
                if (await canLaunchUrl(telLaunchUri)) {
                  await launchUrl(telLaunchUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تعذر فتح تطبيق الهاتف'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.phone, color: Colors.green, size: 20),
              ),
              tooltip: 'اتصال مباشر',
            ),
            
            // زر نسخ الرقم
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: number));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم نسخ الرقم: $number'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.copy, color: Colors.blue, size: 20),
              ),
              tooltip: 'نسخ الرقم',
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail(BuildContext context) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'albuhairaalarabia@gmail.com',
      queryParameters: {
        'subject': 'استفسار عن تطبيق الوقود',
        'body': 'أرغب في الاستفسار عن...',
      },
    );

    launchUrl(emailLaunchUri).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر فتح تطبيق البريد الإلكتروني'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Widget _buildFAQSection() {
    final List<Map<String, String>> faqItems = [
      {
        'question': 'كيف يمكنني طلب وقود؟',
        'answer': 'يمكنك طلب الوقود من خلال التبويب الثاني "طلب وقود" واتباع الخطوات'
      },
      {
        'question': 'ما هي طرق الدفع المتاحة؟',
        'answer': 'نحن نقبل التحويل البنكي '
      },
      {
        'question': 'كم تستغرق وقت التوصيل؟',
        'answer': 'يتم التوصيل خلال يوم - يومان عمل حسب الموقع والازدحام'
      },
      {
        'question': 'كيف أتتبع طلبي؟',
        'answer': 'يمكنك تتبع طلبك من خلال الوجهه الرئيسيه ثم اختيار "تتبع الطلب"'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'الأسئلة الشائعة',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16),
        ...faqItems.map((faq) => _buildFAQItem(
          question: faq['question']!,
          answer: faq['answer']!,
        )),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                answer,
                style: GoogleFonts.cairo(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          iconColor: Colors.white,
          collapsedIconColor: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E).withOpacity(0.7),
            Color(0xFF283593).withOpacity(0.5),
            Color(0xFF303F9F).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(Icons.contact_phone, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'معلومات الاتصال',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildContactInfoItem(
            icon: Icons.phone,
            title: 'الهاتف',
            value: '+96654708118',
            color: Color(0xFF81C784),
          ),
          _buildContactInfoItem(
            icon: Icons.email,
            title: 'البريد الإلكتروني',
            value: 'albuhairaalarabia@gmail.com',
            color: Color(0xFFFFB74D),
          ),
          _buildContactInfoItem(
            icon: Icons.access_time,
            title: 'ساعات العمل',
            value: '24/7',
            color: Color(0xFF64B5F6),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (title == 'الهاتف') {
                _showContactNumbers(context as BuildContext);
              } else if (title == 'البريد الإلكتروني') {
                _sendEmail(context as BuildContext);
              }
            },
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportHoursSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E).withOpacity(0.7),
            Color(0xFF283593).withOpacity(0.5),
            Color(0xFF303F9F).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(Icons.schedule, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'ساعات الدعم',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSupportHourItem('السبت - الخميس', '8:00 ص - 12:00 م'),
          _buildSupportHourItem('الجمعة', '4:00 م - 12:00 م'),
          _buildSupportHourItem('الدعم الطارئ', '24/7'),
        ],
      ),
    );
  }

  Widget _buildSupportHourItem(String day, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: GoogleFonts.cairo(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}